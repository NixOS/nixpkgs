{ stdenv, pkgs, fetchurl, zlib, gmp, lib }:

# from justinwoo/easy-purescript-nix
# https://github.com/justinwoo/easy-purescript-nix/blob/d383972c82620a712ead4033db14110497bc2c9c/purs.nix

let
  dynamic-linker = stdenv.cc.bintools.dynamicLinker;

  patchelf = libPath :
    lib.optionalString (!stdenv.isDarwin) ''
          chmod u+w $PURS
          patchelf --interpreter ${dynamic-linker} --set-rpath ${libPath} $PURS
          chmod u-w $PURS
        '';

in stdenv.mkDerivation rec {
  pname = "purescript";
  version = "0.15.10";

  # These hashes can be updated automatically by running the ./update.sh script.
  src =
    if stdenv.isDarwin
    then
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
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
    mainProgram = "purs";
    changelog = "https://github.com/purescript/purescript/releases/tag/v${version}";
  };
}
