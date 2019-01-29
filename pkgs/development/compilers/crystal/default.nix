{ stdenv, lib, fetchFromGitHub, fetchurl, makeWrapper
, gmp, openssl, readline, tzdata, libxml2, libyaml
, boehmgc, libatomic_ops, pcre, libevent, libiconv, llvm, clang, which, zlib }:

let
  binaryVersion = "0.26.0";
  releaseDate = "2018-08-29";

  arch = {
    "x86_64-linux"  = "linux-x86_64";
    "i686-linux"    = "linux-i686";
    "x86_64-darwin" = "darwin-x86_64";
  }."${stdenv.system}" or (throw "system ${stdenv.system} not supported");

  checkInputs = [ gmp openssl readline libxml2 libyaml tzdata ];

  # we could turn this into a function instead in case we cannot use the same
  # binary to build multiple versions
  binary = stdenv.mkDerivation rec {
    name = "crystal-binary-${binaryVersion}";

    src = fetchurl {
      url = "https://github.com/crystal-lang/crystal/releases/download/${binaryVersion}/crystal-${binaryVersion}-1-${arch}.tar.gz";
      sha256 = {
        "x86_64-linux"  = "1xban102yiiwmlklxvn3xp3q546bp8hlxxpakayajkhhnpl6yv45";
        "i686-linux"    = "1igspf1lrv7wpmz0pfrkbx8m1ykvnv4zhic53cav4nicppm2v0ic";
        "x86_64-darwin" = "0hzc65ccajr0yhmvi5vbdgbzbp1gbjy56da24ds3zwwkam1ddk0k";
      }."${stdenv.system}";
    };

    buildCommand = ''
      mkdir -p $out
      tar --strip-components=1 -C $out -xf ${src}
    '';
  };

  generic = { version, sha256, doCheck ? true }:
  stdenv.mkDerivation rec {
    inherit doCheck;
    name = "crystal-${version}";

    src = fetchFromGitHub {
      owner  = "crystal-lang";
      repo   = "crystal";
      rev    = version;
      inherit sha256;
    };

    # the first bit can go when https://github.com/crystal-lang/crystal/pull/6788 is merged
    postPatch = ''
      substituteInPlace src/compiler/crystal/config.cr \
        --replace '{{ `date "+%Y-%m-%d"`.stringify.chomp }}' '"${releaseDate}"'
      ln -s spec/compiler spec/std
      substituteInPlace spec/std/process_spec.cr \
        --replace /bin/ /run/current-system/sw/bin
    '';

    buildInputs = [
      boehmgc libatomic_ops pcre libevent
      llvm zlib openssl
    ] ++ stdenv.lib.optionals stdenv.isDarwin [
      libiconv
    ];

    nativeBuildInputs = [ binary makeWrapper which ];


    makeFlags = [
      "CRYSTAL_CONFIG_BUILD_DATE=${releaseDate}"
      "CRYSTAL_CONFIG_VERSION=${version}"
    ];

    buildFlags = [
      "all" "docs"
    ];

    FLAGS = [
      "--release"
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
      platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
    };
  };

in rec {
  crystal_0_25 = generic {
    version = "0.25.1";
    sha256  = "15xmbkalsdk9qpc6wfpkly3sifgw6a4ai5jzlv78dh3jp7glmgyl";
    doCheck = false;
  };

  crystal_0_26 = generic {
    version = "0.26.1";
    sha256  = "0jwxrqm99zcjj82gyl6bzvnfj79nwzqf8sa1q3f66q9p50v44f84";
    doCheck = false; # about 20 tests out of more than 14000 are failing
  };

  crystal = crystal_0_26;
}
