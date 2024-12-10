{
  lib,
  stdenv,
  fetchurl,
  zlib,
}:

let
  ARCH =
    {
      x86_64-linux = "linux64";
      aarch64-linux = "linux64";
      x86_64-cygwin = "cygwin64";
      x86_64-darwin = "mac64";
      aarch64-darwin = "mac64";
    }
    ."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "picat";
  version = "3.6";

  src = fetchurl {
    url = "http://picat-lang.org/download/picat36_src.tar.gz";
    hash = "sha256-DjP1cjKxRLxMjiHmYX42+kaG5//09IrPIc1O75gLA6k=";
  };

  buildInputs = [ zlib ];

  inherit ARCH;

  hardeningDisable = [ "format" ];
  enableParallelBuilding = true;

  buildPhase = ''
    cd emu
    make -j $NIX_BUILD_CORES -f Makefile.$ARCH
  '';
  installPhase = ''
    mkdir -p $out/bin $out/share
    cp picat $out/bin/
    cp -r ../doc $out/share/doc
    cp -r ../exs $out/share/examples
  '';

  meta = with lib; {
    description = "Logic-based programming langage";
    mainProgram = "picat";
    homepage = "http://picat-lang.org/";
    license = licenses.mpl20;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-cygwin"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with maintainers; [
      earldouglas
      thoughtpolice
    ];
  };
}
