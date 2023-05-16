{ stdenv, pkgs, fetchurl, zlib, gmp, lib }:

# from justinwoo/easy-purescript-nix
# https://github.com/justinwoo/easy-purescript-nix/blob/d383972c82620a712ead4033db14110497bc2c9c/purs.nix

let
  dynamic-linker = stdenv.cc.bintools.dynamicLinker;

  patchelf = libPath :
<<<<<<< HEAD
    lib.optionalString (!stdenv.isDarwin) ''
=======
    if stdenv.isDarwin
      then ""
      else
        ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
          chmod u+w $PURS
          patchelf --interpreter ${dynamic-linker} --set-rpath ${libPath} $PURS
          chmod u-w $PURS
        '';

in stdenv.mkDerivation rec {
  pname = "purescript";
<<<<<<< HEAD
  version = "0.15.10";
=======
  version = "0.15.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # These hashes can be updated automatically by running the ./update.sh script.
  src =
    if stdenv.isDarwin
    then
<<<<<<< HEAD
      (if stdenv.isAarch64
      then
      fetchurl {
        url = "https://github.com/${pname}/${pname}/releases/download/v${version}/macos-arm64.tar.gz";
        sha256 = "1pk6mkjy09qvh8lsygb5gb77i2fqwjzz8jdjkxlyzynp3wpkcjp7";
      }
      else
      fetchurl {
        url = "https://github.com/${pname}/${pname}/releases/download/v${version}/macos.tar.gz";
        sha256 = "14yd00v3dsnnwj2f645vy0apnp1843ms9ffd2ccv7bj5p4kxsdzg";
      })
    else
    fetchurl {
      url = "https://github.com/${pname}/${pname}/releases/download/v${version}/linux64.tar.gz";
      sha256 = "03p5f2m5xvrqgiacs4yfc2dgz6frlxy90h6z1nm6wan40p2vd41r";
=======
    fetchurl {
      url = "https://github.com/${pname}/${pname}/releases/download/v${version}/macos.tar.gz";
      sha256 = "1xxg79rlf7li9f73wdbwif1dyy4hnzpypy6wx4zbnvap53habq9f";
    }
    else
    fetchurl {
      url = "https://github.com/${pname}/${pname}/releases/download/v${version}/linux64.tar.gz";
      sha256 = "0rabinklsd8bs16f03zv7ij6d1lv4w2xwvzzgkwc862gpqvz9jq3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };


  buildInputs = [ zlib gmp ];
  libPath = lib.makeLibraryPath buildInputs;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin
    PURS="$out/bin/purs"

    install -D -m555 -T purs $PURS
    ${patchelf libPath}

    mkdir -p $out/share/bash-completion/completions
    $PURS --bash-completion-script $PURS > $out/share/bash-completion/completions/purs-completion.bash
  '';

  passthru = {
    updateScript = ./update.sh;
    tests = {
      minimal-module = pkgs.callPackage ./test-minimal-module {};
    };
  };

  meta = with lib; {
    description = "A strongly-typed functional programming language that compiles to JavaScript";
    homepage = "https://www.purescript.org/";
    license = licenses.bsd3;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ justinwoo mbbx6spp cdepillabout ];
<<<<<<< HEAD
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
=======
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mainProgram = "purs";
    changelog = "https://github.com/purescript/purescript/releases/tag/v${version}";
  };
}
