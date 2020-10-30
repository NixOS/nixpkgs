{ stdenv, buildPackages, lib
, fetchurl, fetchpatch, fetchFromSavannah, fetchFromGitHub
, zlib, openssl, gdbm, ncurses, readline, groff, libyaml, libffi, autoreconfHook, bison
, autoconf, libiconv, libobjc, libunwind, Foundation
, buildEnv, bundler, bundix
, makeWrapper, buildRubyGem, defaultGemConfig, removeReferencesTo
} @ args:

let
  op = lib.optional;
  ops = lib.optionals;
  opString = lib.optionalString;
  patchSet = import ./rvm-patchsets.nix { inherit fetchFromGitHub; };
  config = import ./config.nix { inherit fetchFromSavannah; };
  rubygems = import ./rubygems { inherit stdenv lib fetchurl fetchpatch; };

  # Contains the ruby version heuristics
  rubyVersion = import ./ruby-version.nix { inherit lib; };

  # Needed during postInstall
  buildRuby =
    if stdenv.hostPlatform == stdenv.buildPlatform
    then "$out/bin/ruby"
    else "${buildPackages.ruby}/bin/ruby";

  generic = { version, sha256 }: let
    ver = version;
    tag = ver.gitTag;
    atLeast27 = lib.versionAtLeast ver.majMin "2.7";
    baseruby = self.override {
      useRailsExpress = false;
      docSupport = false;
      rubygemsSupport = false;
    };
    self = lib.makeOverridable (
      { stdenv, buildPackages, lib
      , fetchurl, fetchpatch, fetchFromSavannah, fetchFromGitHub
      , useRailsExpress ? true
      , rubygemsSupport ? true
      , zlib, zlibSupport ? true
      , openssl, opensslSupport ? true
      , gdbm, gdbmSupport ? true
      , ncurses, readline, cursesSupport ? true
      , groff, docSupport ? true
      , libyaml, yamlSupport ? true
      , libffi, fiddleSupport ? true
      # ruby -e "puts RbConfig::CONFIG['configure_args']"
      # puts a reference to the C compiler in the binary.
      # This might be required by some gems at runtime,
      # but we allow to strip it out for smaller closure size.
      , removeReferencesTo, removeReferenceToCC ? true
      , autoreconfHook, bison, autoconf
      , buildEnv, bundler, bundix
      , libiconv, libobjc, libunwind, Foundation
      , makeWrapper, buildRubyGem, defaultGemConfig
      }:
      stdenv.mkDerivation rec {
        pname = "ruby";
        inherit version;

        src = if useRailsExpress then fetchFromGitHub {
          owner  = "ruby";
          repo   = "ruby";
          rev    = tag;
          sha256 = sha256.git;
        } else fetchurl {
          url = "https://cache.ruby-lang.org/pub/ruby/${ver.majMin}/ruby-${ver}.tar.gz";
          sha256 = sha256.src;
        };

        # Have `configure' avoid `/usr/bin/nroff' in non-chroot builds.
        NROFF = if docSupport then "${groff}/bin/nroff" else null;

        outputs = [ "out" ] ++ lib.optional docSupport "devdoc";

        nativeBuildInputs = [ autoreconfHook bison ]
          ++ (op docSupport groff)
          ++ op (stdenv.buildPlatform != stdenv.hostPlatform) buildPackages.ruby;
        buildInputs = [ autoconf ]
          ++ (op fiddleSupport libffi)
          ++ (ops cursesSupport [ ncurses readline ])
          ++ (op zlibSupport zlib)
          ++ (op opensslSupport openssl)
          ++ (op gdbmSupport gdbm)
          ++ (op yamlSupport libyaml)
          # Looks like ruby fails to build on darwin without readline even if curses
          # support is not enabled, so add readline to the build inputs if curses
          # support is disabled (if it's enabled, we already have it) and we're
          # running on darwin
          ++ op (!cursesSupport && stdenv.isDarwin) readline
          ++ ops stdenv.isDarwin [ libiconv libobjc libunwind Foundation ];

        enableParallelBuilding = true;

        patches =
          (import ./patchsets.nix {
            inherit patchSet useRailsExpress ops fetchpatch;
            patchLevel = ver.patchLevel;
          }).${ver.majMinTiny};

        postUnpack = opString rubygemsSupport ''
          rm -rf $sourceRoot/{lib,test}/rubygems*
          cp -r ${rubygems}/lib/rubygems* $sourceRoot/lib
          cp -r ${rubygems}/test/rubygems $sourceRoot/test
        '';

        postPatch = ''
          sed -i configure.ac -e '/config.guess/d'
          cp --remove-destination ${config}/config.guess tool/
          cp --remove-destination ${config}/config.sub tool/
        '';

        # Force the revision.h generation. Somehow `revision.tmp` is an empty
        # file and because we don't add `git` to buildInputs, hence the check is
        # always true.
        # https://github.com/ruby/ruby/commit/97a5af62a318fcd93a4e5e4428d576c0280ddbae
        buildFlags = lib.optionals atLeast27 [ "REVISION_LATEST=0" ];

        configureFlags = ["--enable-shared" "--enable-pthread" "--with-soname=ruby-${version}"]
          ++ op useRailsExpress "--with-baseruby=${baseruby}/bin/ruby"
          ++ op (!docSupport) "--disable-install-doc"
          ++ ops stdenv.isDarwin [
            # on darwin, we have /usr/include/tk.h -- so the configure script detects
            # that tk is installed
            "--with-out-ext=tk"
            # on yosemite, "generating encdb.h" will hang for a very long time without this flag
            "--with-setjmp-type=setjmp"
            # silence linker warnings after upgrading darwin.cctools to 949.0.1,
            # which ruby treats as problem with LDFLAGS
            # https://github.com/NixOS/nixpkgs/issues/101330
            "LDFLAGS=-Wl,-w"
          ]
          ++ op (stdenv.hostPlatform != stdenv.buildPlatform)
             "--with-baseruby=${buildRuby}";

        preConfigure = opString docSupport ''
          configureFlagsArray+=("--with-ridir=$devdoc/share/ri")
        '';

        # fails with "16993 tests, 2229489 assertions, 105 failures, 14 errors, 89 skips"
        # mostly TZ- and patch-related tests
        # TZ- failures are caused by nix sandboxing, I didn't investigate others
        doCheck = false;

        preInstall = ''
          # Ruby installs gems here itself now.
          mkdir -pv "$out/${passthru.gemPath}"
          export GEM_HOME="$out/${passthru.gemPath}"
        '';

        installFlags = stdenv.lib.optional docSupport "install-doc";
        # Bundler tries to create this directory
        postInstall = ''
          # Remove unnecessary groff reference from runtime closure, since it's big
          sed -i '/NROFF/d' $out/lib/ruby/*/*/rbconfig.rb
          ${
            lib.optionalString removeReferenceToCC ''
              # Get rid of the CC runtime dependency
              ${removeReferencesTo}/bin/remove-references-to \
                -t ${stdenv.cc} \
                $out/lib/libruby*
            ''
          }
          # Bundler tries to create this directory
          mkdir -p $out/nix-support
          cat > $out/nix-support/setup-hook <<EOF
          addGemPath() {
            addToSearchPath GEM_PATH \$1/${passthru.gemPath}
          }
          addRubyLibPath() {
            addToSearchPath RUBYLIB \$1/lib/ruby/site_ruby
            addToSearchPath RUBYLIB \$1/lib/ruby/site_ruby/${ver.libDir}
            addToSearchPath RUBYLIB \$1/lib/ruby/site_ruby/${ver.libDir}/${stdenv.targetPlatform.system}
          }

          addEnvHooks "$hostOffset" addGemPath
          addEnvHooks "$hostOffset" addRubyLibPath
          EOF

          rbConfig=$(find $out/lib/ruby -name rbconfig.rb)
        '' + opString docSupport ''
          # Prevent the docs from being included in the closure
          sed -i "s|\$(DESTDIR)$devdoc|\$(datarootdir)/\$(RI_BASE_NAME)|" $rbConfig
          sed -i "s|'--with-ridir=$devdoc/share/ri'||" $rbConfig

          # Add rbconfig shim so ri can find docs
          mkdir -p $devdoc/lib/ruby/site_ruby
          cp ${./rbconfig.rb} $devdoc/lib/ruby/site_ruby/rbconfig.rb
        '' + opString useRailsExpress ''
          # Prevent the baseruby from being included in the closure.
          sed -i '/^  CONFIG\["BASERUBY"\]/d' $rbConfig
          sed -i "s|'--with-baseruby=${baseruby}/bin/ruby'||" $rbConfig
        '';

        meta = with stdenv.lib; {
          description = "The Ruby language";
          homepage    = "http://www.ruby-lang.org/en/";
          license     = licenses.ruby;
          maintainers = with maintainers; [ vrthra manveru marsam ];
          platforms   = platforms.all;
        };

        passthru = rec {
          version = ver;
          rubyEngine = "ruby";
          baseRuby = baseruby;
          libPath = "lib/${rubyEngine}/${ver.libDir}";
          gemPath = "lib/${rubyEngine}/gems/${ver.libDir}";
          devEnv = import ./dev.nix {
            inherit buildEnv bundler bundix;
            ruby = self;
          };

          inherit (import ../../ruby-modules/with-packages {
            inherit lib stdenv makeWrapper buildRubyGem buildEnv;
            gemConfig = defaultGemConfig;
            ruby = self;
          }) withPackages gems;

          # deprecated 2016-09-21
          majorVersion = ver.major;
          minorVersion = ver.minor;
          teenyVersion = ver.tiny;
          patchLevel = ver.patchLevel;
        };
      }
    ) args; in self;

in {
  ruby_2_5 = generic {
    version = rubyVersion "2" "5" "8" "";
    sha256 = {
      src = "16md4jspjwixjlbhx3pnd5iwpca07p23ghkxkqd82sbchw3xy2vc";
      git = "19gkk3q9l33cwkfsp5k8f8fipq7gkyqkqirm9farbvy425519rv2";
    };
  };

  ruby_2_6 = generic {
    version = rubyVersion "2" "6" "6" "";
    sha256 = {
      src = "1492x795qzgp3zhpl580kd1sdp50n5hfsmpbfhdsq2rnxwyi8jrn";
      git = "1jr9v99a7awssqmw7531afbx4a8i9x5yfqyffha545g7r4s7kj50";
    };
  };

  ruby_2_7 = generic {
    version = rubyVersion "2" "7" "2" "";
    sha256 = {
      src = "1m63461mxi3fg4y3bspbgmb0ckbbb1ldgf9xi0piwkpfsk80cmvf";
      git = "0kbgznf1yprfp9645k31ra5f4757b7fichzi0hdg6nxkj90853s0";
    };
  };
}
