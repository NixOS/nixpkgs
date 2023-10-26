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
  version = "0.15.12";

  # These hashes can be updated automatically by running the ./update.sh script.
  src =
    if stdenv.isDarwin
    then
      (if stdenv.isAarch64
      then
      fetchurl {
        url = "https://github.com/${pname}/${pname}/releases/download/v${version}/macos-arm64.tar.gz";
        sha256 = "0s8j9svgxir0rb0wxkshwal60962g5z0pysdyrjgcr9r77y5gffk";
      }
      else
      fetchurl {
        url = "https://github.com/${pname}/${pname}/releases/download/v${version}/macos.tar.gz";
        sha256 = "13d2mmphxy9f9yy242qsm58hipr612jymwy7lhf0is4y4m2lvrk2";
      })
    else
    fetchurl {
      url = "https://github.com/${pname}/${pname}/releases/download/v${version}/linux64.tar.gz";
      sha256 = "05xwplibkv86iiwpv29vg3zxp5yw7waw86zh08q3p0qx355wjy73";
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
