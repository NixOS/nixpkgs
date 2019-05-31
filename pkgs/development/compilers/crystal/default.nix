{ stdenv, lib, fetchFromGitHub, fetchurl, makeWrapper
, gmp, openssl, readline, tzdata, libxml2, libyaml
, boehmgc, libatomic_ops, pcre, libevent, libiconv, llvm, clang, which, zlib }:

# We need multiple binaries as a given binary isn't always able to build
# (even slightly) older or newer version.
# - 0.26.1 can build 0.25.x and 0.26.x but not 0.27.x
# - 0.27.2 can build 0.27.x but not 0.25.x and 0.26.x
#
# We need to keep around at least the latest version released with a stable
# NixOS

let
  archs = {
    "x86_64-linux"  = "linux-x86_64";
    "i686-linux"    = "linux-i686";
    "x86_64-darwin" = "darwin-x86_64";
  };

  arch = archs."${stdenv.system}" or (throw "system ${stdenv.system} not supported");

  checkInputs = [ gmp openssl readline libxml2 libyaml tzdata ];

  genericBinary = { version, sha256s, rel ? 1 }:
  stdenv.mkDerivation rec {
    name = "crystal-binary-${version}";

    src = fetchurl {
      url = "https://github.com/crystal-lang/crystal/releases/download/${version}/crystal-${version}-${toString rel}-${arch}.tar.gz";
      sha256 = sha256s."${stdenv.system}";
    };

    buildCommand = ''
      mkdir -p $out
      tar --strip-components=1 -C $out -xf ${src}
    '';
  };

  generic = { version, sha256, binary, doCheck ? true }:
  stdenv.mkDerivation rec {
    inherit doCheck;
    name = "crystal-${version}";

    src = fetchFromGitHub {
      owner  = "crystal-lang";
      repo   = "crystal";
      rev    = version;
      inherit sha256;
    };

    postPatch = ''
      ln -s spec/compiler spec/std
      substituteInPlace spec/std/process_spec.cr \
        --replace /bin/ /run/current-system/sw/bin/
    '';

    buildInputs = [
      boehmgc libatomic_ops pcre libevent
      llvm zlib openssl
    ] ++ stdenv.lib.optionals stdenv.isDarwin [
      libiconv
    ];

    nativeBuildInputs = [ binary makeWrapper which ];

    makeFlags = [
      "CRYSTAL_CONFIG_VERSION=${version}"
    ];

    buildFlags = [
      "all" "docs"
    ];

    FLAGS = [
      "--release"
      "--no-debug"
      "--single-module" # needed for deterministic builds
    ];

    # We *have* to add `which` to the PATH or crystal is unable to build stuff
    # later if which is not available.
    installPhase = ''
      runHook preInstall

      install -Dm755 .build/crystal $out/bin/crystal
      wrapProgram $out/bin/crystal \
          --suffix PATH : ${lib.makeBinPath [ clang which ]} \
          --suffix CRYSTAL_PATH : lib:$out/lib/crystal \
          --suffix LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}
      install -dm755 $out/lib/crystal
      cp -r src/* $out/lib/crystal/

      install -dm755 $out/share/doc/crystal/api
      cp -r docs/* $out/share/doc/crystal/api/
      cp -r samples $out/share/doc/crystal/

      install -Dm644 etc/completion.bash $out/share/bash-completion/completions/crystal
      install -Dm644 etc/completion.zsh $out/share/zsh/site-functions/_crystal

      install -Dm644 man/crystal.1 $out/share/man/man1/crystal.1

      install -Dm644 -t $out/share/licenses/crystal LICENSE README.md

      runHook postInstall
    '';

    enableParallelBuilding = true;

    dontStrip = true;

    checkTarget = "spec";

    preCheck = ''
      export LIBRARY_PATH=${lib.makeLibraryPath checkInputs}:$LIBRARY_PATH
    '';

    meta = with lib; {
      description = "A compiled language with Ruby like syntax and type inference";
      homepage = https://crystal-lang.org/;
      license = licenses.asl20;
      maintainers = with maintainers; [ manveru david50407 peterhoeg ];
      platforms = builtins.attrNames archs;
    };
  };

in rec {
  binaryCrystal_0_26 = genericBinary {
    version = "0.26.1";
    sha256s = {
      "x86_64-linux"  = "1xban102yiiwmlklxvn3xp3q546bp8hlxxpakayajkhhnpl6yv45";
      "i686-linux"    = "1igspf1lrv7wpmz0pfrkbx8m1ykvnv4zhic53cav4nicppm2v0ic";
      "x86_64-darwin" = "1mri8bfrcldl69gczxpihxpv1shn4bijx28m3qby8vnk0ii63n9s";
    };
  };

  binaryCrystal_0_27 = genericBinary {
    version = "0.27.2";
    sha256s = {
      "x86_64-linux"  = "05l5x7kx2acgnv42fj3rr17z73ix06zvi05h7d7vf3kw0izxrasm";
      "i686-linux"    = "1iwizkvn6pglc0azkyfhlmk9ap793krdgcnbihd1kvrvs4cz0mm9";
      "x86_64-darwin" = "14c69ac2dmfwmb5q56ps3xyxxb0mrbc91ahk9h07c8fiqfii3k9g";
    };
  };

  crystal_0_25 = generic {
    version = "0.25.1";
    sha256  = "15xmbkalsdk9qpc6wfpkly3sifgw6a4ai5jzlv78dh3jp7glmgyl";
    doCheck = false;
    binary = binaryCrystal_0_26;
  };

  crystal_0_26 = generic {
    version = "0.26.1";
    sha256  = "0jwxrqm99zcjj82gyl6bzvnfj79nwzqf8sa1q3f66q9p50v44f84";
    doCheck = false; # about 20 tests out of more than 14000 are failing
    binary = binaryCrystal_0_26;
  };

  crystal_0_27 = generic {
    version = "0.27.2";
    sha256  = "0vxqnpqi85yh0167nrkbksxsni476iwbh6y3znbvbjbbfhsi3nsj";
    doCheck = false; # about 20 tests out of more than 15000 are failing
    binary = binaryCrystal_0_27;
  };

  crystal = crystal_0_27;
}
