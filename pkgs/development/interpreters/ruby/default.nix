{ stdenv, lib, fetchurl, fetchpatch, fetchFromSavannah, fetchFromGitHub
, zlib, openssl, gdbm, ncurses, readline, groff, libyaml, libffi, autoreconfHook, bison
, autoconf, darwin ? null
, buildEnv, bundler, bundix
} @ args:

let
  op = lib.optional;
  ops = lib.optionals;
  opString = lib.optionalString;
  patchSet = import ./rvm-patchsets.nix { inherit fetchFromGitHub; };
  config = import ./config.nix { inherit fetchFromSavannah; };
  rubygemsSrc = import ./rubygems-src.nix { inherit fetchurl; };
  rubygemsPatch = fetchpatch {
    url = "https://github.com/zimbatm/rubygems/compare/v2.6.6...v2.6.6-nix.patch";
    sha256 = "0297rdb1m6v75q8665ry9id1s74p9305dv32l95ssf198liaihhd";
  };
  unpackdir = obj:
    lib.removeSuffix ".tgz"
      (lib.removeSuffix ".tar.gz" obj.name);

  # Contains the ruby version heuristics
  rubyVersion = import ./ruby-version.nix { inherit lib; };

  generic = { version, sha256 }: let
    ver = version;
    tag = ver.gitTag;
    isRuby20 = ver.majMin == "2.0";
    isRuby21 = ver.majMin == "2.1";
    baseruby = self.override { useRailsExpress = false; };
    self = lib.makeOverridable (
      { stdenv, lib, fetchurl, fetchpatch, fetchFromSavannah, fetchFromGitHub
      , useRailsExpress ? true
      , zlib, zlibSupport ? true
      , openssl, opensslSupport ? true
      , gdbm, gdbmSupport ? true
      , ncurses, readline, cursesSupport ? true
      , groff, docSupport ? false
      , libyaml, yamlSupport ? true
      , libffi, fiddleSupport ? true
      , autoreconfHook, bison, autoconf
      , darwin ? null
      , buildEnv, bundler, bundix
      }:
      let rubySrc =
        if useRailsExpress then fetchFromGitHub {
          owner  = "ruby";
          repo   = "ruby";
          rev    = tag;
          sha256 = sha256.git;
        } else fetchurl {
          url = "http://cache.ruby-lang.org/pub/ruby/${ver.majMin}/ruby-${ver}.tar.gz";
          sha256 = sha256.src;
        };
      in
      stdenv.mkDerivation rec {
        name = "ruby-${version}";

        srcs = [ rubySrc rubygemsSrc ];
        sourceRoot =
          if useRailsExpress then
            rubySrc.name
          else
            unpackdir rubySrc;

        # Have `configure' avoid `/usr/bin/nroff' in non-chroot builds.
        NROFF = "${groff}/bin/nroff";

        nativeBuildInputs = ops useRailsExpress [ autoreconfHook bison ];
        buildInputs =
             (op fiddleSupport libffi)
          ++ (ops cursesSupport [ ncurses readline ])
          ++ (op docSupport groff)
          ++ (op zlibSupport zlib)
          ++ (op opensslSupport openssl)
          ++ (op gdbmSupport gdbm)
          ++ (op yamlSupport libyaml)
          # Looks like ruby fails to build on darwin without readline even if curses
          # support is not enabled, so add readline to the build inputs if curses
          # support is disabled (if it's enabled, we already have it) and we're
          # running on darwin
          ++ (op (!cursesSupport && stdenv.isDarwin) readline)
          ++ (ops stdenv.isDarwin (with darwin; [ libiconv libobjc libunwind ]));

        enableParallelBuilding = true;

        hardeningDisable = lib.optional isRuby20 "format";

        patches =
          (import ./patchsets.nix {
            inherit patchSet useRailsExpress ops;
            patchLevel = ver.patchLevel;
          })."${ver.majMinTiny}";

        postUnpack = ''
          cp -r ${unpackdir rubygemsSrc} ${sourceRoot}/rubygems
          pushd ${sourceRoot}/rubygems
          patch -p1 < ${rubygemsPatch}
          popd
        '' + opString isRuby21 ''
          rm "$sourceRoot/enc/unicode/name2ctype.h"
        '';

        postPatch = if isRuby21 then ''
          rm tool/config_files.rb
          cp ${config}/config.guess tool/
          cp ${config}/config.sub tool/
        ''
        else opString useRailsExpress ''
          sed -i configure.in -e '/config.guess/d'
          cp ${config}/config.guess tool/
          cp ${config}/config.sub tool/
        '';

        configureFlags = ["--enable-shared" "--enable-pthread"]
          ++ op useRailsExpress "--with-baseruby=${baseruby}/bin/ruby"
          ++ op (!docSupport) "--disable-install-doc"
          ++ ops stdenv.isDarwin [
            # on darwin, we have /usr/include/tk.h -- so the configure script detects
            # that tk is installed
            "--with-out-ext=tk"
            # on yosemite, "generating encdb.h" will hang for a very long time without this flag
            "--with-setjmp-type=setjmp"
          ];

        installFlags = stdenv.lib.optionalString docSupport "install-doc";
        # Bundler tries to create this directory
        postInstall = ''
          # Update rubygems
          pushd rubygems
          $out/bin/ruby setup.rb
          popd

          # Remove unnecessary groff reference from runtime closure, since it's big
          sed -i '/NROFF/d' $out/lib/ruby/*/*/rbconfig.rb

          # Bundler tries to create this directory
          mkdir -pv $out/${passthru.gemPath}
          mkdir -p $out/nix-support
          cat > $out/nix-support/setup-hook <<EOF
          addGemPath() {
            addToSearchPath GEM_PATH \$1/${passthru.gemPath}
          }

          envHooks+=(addGemPath)
          EOF
        '' + opString useRailsExpress ''
          rbConfig=$(find $out/lib/ruby -name rbconfig.rb)

          # Prevent the baseruby from being included in the closure.
          sed -i '/^  CONFIG\["BASERUBY"\]/d' $rbConfig
          sed -i "s|'--with-baseruby=${baseruby}/bin/ruby'||" $rbConfig
        '';

        meta = with stdenv.lib; {
          description = "The Ruby language";
          homepage    = http://www.ruby-lang.org/en/;
          license     = licenses.ruby;
          maintainers = with maintainers; [ vrthra manveru ];
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

          # deprecated 2016-09-21
          majorVersion = ver.major;
          minorVersion = ver.minor;
          teenyVersion = ver.tiny;
          patchLevel = ver.patchLevel;
        };
      }
    ) args; in self;

in {
  ruby_2_0_0 = generic {
    version = rubyVersion "2" "0" "0" "p648";
    sha256 = {
      src = "1y3n4c6xw2wki7pyjpq5zpbgxnw5i3jc8mcpj6rk7hs995mvv446";
      git = "0ncjfq4hfqj9kcr8pbll6kypwnmcgs8w7l4466qqfyv7jj3yjd76";
    };
  };

  ruby_2_1_10 = generic {
    version = rubyVersion "2" "1" "10" "";
    sha256 = {
      src = "086x66w51lg41abjn79xb7f6xsryymkcc3nvakmkjnjyg96labpv";
      git = "133phd5r5y0np5lc9nqif93l7yb13yd52aspyl6c46z5jhvhyvfi";
    };
  };

  ruby_2_2_8 = generic {
    version = rubyVersion "2" "2" "8" "";
    sha256 = {
      src = "12i6v5i0djl4xx3x7fq12snqb5d4drqjmnwqs05fby4bagcbjdwg";
      git = "16nw0795nhrj13crp5x4jis8hmi3gsyjl96pwk698wlrb89lf9bw";
    };
  };

  ruby_2_3_5 = generic {
    version = rubyVersion "2" "3" "5" "";
    sha256 = {
      src = "1k6x4g68lq30i0myip5bn56rcbwjxmqq95j1fkdgbvwbnaxzfqjl";
      git = "0spwqz4b5xxqzs13azsd4xz4jkc3is7d9q4s6s2qilb8ib4863jl";
    };
  };

  ruby_2_4_2 = generic {
    version = rubyVersion "2" "4" "2" "";
    sha256 = {
      src = "174cdiz3am1f76vsnm3iqi9c5vqphypbf9kbxx6vqqmj01gfgfck";
      git = "1w83kzak3m6vv3k09ynfw9vpgc7vpmij3x3zmgrhwm4ds1sp5irl";
    };
  };
}
