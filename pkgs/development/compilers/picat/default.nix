{ lib, stdenv, fetchurl, zlib }:

let
  ARCH = {
    i686-linux    = "linux32";
    x86_64-linux  = "linux64";
    aarch64-linux = "linux64";
  }."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "picat";
  version = "3.0p4";

  src = fetchurl {
    url    = "http://picat-lang.org/download/picat30_4_src.tar.gz";
    sha256 = "1rwin44m7ni2h2v51sh2r8gj2k6wm6f86zgaylrria9jr57inpqj";
  };

  buildInputs = [ zlib ];

  inherit ARCH;

  hardeningDisable = [ "format" ];
  enableParallelBuilding = true;

  buildPhase = "cd emu && make -j $NIX_BUILD_CORES -f Makefile.$ARCH";
  installPhase = "mkdir -p $out/bin && cp picat $out/bin/picat";

  meta = with lib; {
    description = "Logic-based programming langage";
    homepage    = "http://picat-lang.org/";
    license     = licenses.mpl20;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ earldouglas thoughtpolice ];
  };
}
