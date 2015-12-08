{ stdenv, lib, fetchurl, fetchFromSavannah, fetchFromGitHub
, zlib, openssl, gdbm, ncurses, readline, groff, libyaml, libffi, autoreconfHook, bison
, autoconf, darwin ? null
} @ args:

let
  op = stdenv.lib.optional;
  ops = stdenv.lib.optionals;
  opString = stdenv.lib.optionalString;
  patchSet = import ./rvm-patchsets.nix { inherit fetchFromGitHub; };
  config = import ./config.nix { inherit fetchFromSavannah; };

  generic = { majorVersion, minorVersion, teenyVersion, patchLevel, sha256 }: let
    versionNoPatch = "${majorVersion}.${minorVersion}.${teenyVersion}";
    version = "${versionNoPatch}-p${patchLevel}";
    fullVersionName = if patchLevel != "0" && stdenv.lib.versionOlder versionNoPatch "2.1"
      then version
      else versionNoPatch;
    tag = "v" + stdenv.lib.replaceChars ["." "p" "-"] ["_" "_" ""] fullVersionName;
    isRuby21 = majorVersion == "2" && minorVersion == "1";
    baseruby = self.override { useRailsExpress = false; };
    self = lib.makeOverridable (
      { stdenv, lib, fetchurl, fetchFromSavannah, fetchFromGitHub
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
      }:
      stdenv.mkDerivation rec {
        inherit version;

        name = "ruby-${version}";

        src = if useRailsExpress then fetchFromGitHub {
          owner  = "ruby";
          repo   = "ruby";
          rev    = tag;
          sha256 = sha256.git;
        } else fetchurl {
          url = "http://cache.ruby-lang.org/pub/ruby/${majorVersion}.${minorVersion}/ruby-${fullVersionName}.tar.gz";
          sha256 = sha256.src;
        };

        # Have `configure' avoid `/usr/bin/nroff' in non-chroot builds.
        NROFF = "${groff}/bin/nroff";

        buildInputs = ops useRailsExpress [ autoreconfHook bison ]
          ++ (op fiddleSupport libffi)
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

        patches = (import ./patchsets.nix {
          inherit patchSet useRailsExpress ops patchLevel;
        })."${versionNoPatch}";

        postUnpack = opString isRuby21 ''
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

        meta = {
          license = stdenv.lib.licenses.ruby;
          homepage = "http://www.ruby-lang.org/en/";
          description = "The Ruby language";
          platforms = stdenv.lib.platforms.all;
        };

        passthru = rec {
          inherit majorVersion minorVersion teenyVersion patchLevel;
          rubyEngine = "ruby";
          baseRuby = baseruby;
          libPath = "lib/${rubyEngine}/${versionNoPatch}";
          gemPath = "lib/${rubyEngine}/gems/${versionNoPatch}";
        };
      }
    ) args; in self;

in {
  ruby_1_9_3 = generic {
    majorVersion = "1";
    minorVersion = "9";
    teenyVersion = "3";
    patchLevel = "551";
    sha256 = {
      src = "1s2ibg3s2iflzdv7rfxi1qqkvdbn2dq8gxdn0nxrb77ls5ffanxv";
      git = "1r9xzzxmci2ajb34qb4y1w424mz878zdgzxkfp9w60agldxnb36s";
    };
  };

  ruby_2_0_0 = generic {
    majorVersion = "2";
    minorVersion = "0";
    teenyVersion = "0";
    patchLevel = "647";
    sha256 = {
      src = "1v2vbvydarcx5801gx9lc6gr6dfi0i7qbzwhsavjqbn79rdsz2n8";
      git = "bd9b6cc8ea984b38d245fb3be1b918ec677f29f394ede43bbf5cf00e88edd899";
    };
  };

  ruby_2_1_0 = generic {
    majorVersion = "2";
    minorVersion = "1";
    teenyVersion = "0";
    patchLevel = "0";
    sha256 = {
      src = "17fhfbw8sr13rxfn58wvrhk2f5i88lkna2afn3gdjvprd8gyqf1m";
      git = "12sn532yvznqfz85378ys0b9ggmj7w8ddhzc1pnnlx7mbyy7r2hx";
    };
  };

  ruby_2_1_1 = generic {
    majorVersion = "2";
    minorVersion = "1";
    teenyVersion = "1";
    patchLevel = "0";
    sha256 = {
      src = "0hc9x3mazyvnk94gs19q8mbnanlzk8mv0hii77slkvc8mqqxyhy8";
      git = "1v2ffvyd0xx1h1qd70431zczhvsdiyyw5kjxih4rszd5avzh5grl";
    };
  };

  ruby_2_1_2 = generic {
    majorVersion = "2";
    minorVersion = "1";
    teenyVersion = "2";
    patchLevel = "353";
    sha256 = {
      src = "0db6krc2bd7yha8p96lcqrahjpsz7g7abhni134g708sh53n8apj";
      git = "14f8w3zwngnxsgigffh6h9z3ng53xq8mk126xmwrsmz9n3ypm6l0";
    };
  };

  ruby_2_1_3 = generic {
    majorVersion = "2";
    minorVersion = "1";
    teenyVersion = "3";
    patchLevel = "0";
    sha256 = {
      src = "00bz6jcbxgnllplk4b9lnyc3w8yd3pz5rn11rmca1s8cn6vvw608";
      git = "1pnam9jry2l2mbji3gvrbb7jyisxl99xjz6l1qrccwnfinxxbmhv";
    };
  };

  ruby_2_1_6 = generic {
    majorVersion = "2";
    minorVersion = "1";
    teenyVersion = "6";
    patchLevel = "0";
    sha256 = {
      src = "1r4bs8lfwsypbcf8j2lpv3by40729vp5mh697njizj97fjp644qy";
      git = "18kbjsbmgv6l3p1qxgmjnhh4jl7xdk3c20ycjpp62vrhq7pyzjsm";
    };
  };

  ruby_2_1_7 = generic {
    majorVersion = "2";
    minorVersion = "1";
    teenyVersion = "7";
    patchLevel = "0";
    sha256 = {
      src = "10fxlqmpbq9407zgsx060q22yj4zq6c3czbf29h7xk1rmjb1b77m";
      git = "c5ecad94558547b6a50cf64d379829fecd62f3ca175626827f435237a3c6be5c";
    };
  };

  ruby_2_2_0 = generic {
    majorVersion = "2";
    minorVersion = "2";
    teenyVersion = "0";
    patchLevel = "0";
    sha256 = {
      src = "1z2092fbpc2qkv1j3yj7jdz7qwvqpxqpmcnkphpjcpgvmfaf6wbn";
      git = "1w7rr2nq1bbw6aiagddzlrr3rl95kk33x4pv6570nm072g55ybpi";
    };
  };

  ruby_2_2_2 = generic {
    majorVersion = "2";
    minorVersion = "2";
    teenyVersion = "2";
    patchLevel = "0";
    sha256 = {
      src = "0i4v7l8pnam0by2cza12zldlhrffqchwb2m9shlnp7j2gqqhzz2z";
      git = "08mw1ql2ghy483cp8xzzm78q17simn4l6phgm2gah7kjh9y3vbrn";
    };
  };

  ruby_2_2_3 = generic {
    majorVersion = "2";
    minorVersion = "2";
    teenyVersion = "3";
    patchLevel = "0";
    sha256 = {
      src = "1kpdf7f8pw90n5bckpl2idzggk0nn0240ah92sj4a1w6k4pmyyfz";
      git = "a62301ca31ef23c9ae88ca68c925df5c0cbf4319265befc3a2fa27a56213cb88";
    };
  };
}
