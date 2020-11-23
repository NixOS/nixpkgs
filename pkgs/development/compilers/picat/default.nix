{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation {
  pname = "picat";
  version = "3.0p3";

  src = fetchurl {
    url    = "http://picat-lang.org/download/picat30_3_src.tar.gz";
    sha256 = "052w0vk2xfmky5nv280ysb8in6vaph7i79yvbddqmahzszarq5hw";
  };

  buildInputs = [ zlib ];

  ARCH = if stdenv.hostPlatform.system == "i686-linux" then "linux32"
         else if stdenv.hostPlatform.system == "x86_64-linux" then "linux64"
         else throw "Unsupported system";

  hardeningDisable = [ "format" ];
  enableParallelBuilding = true;

  buildPhase = "cd emu && make -j $NIX_BUILD_CORES -f Makefile.$ARCH";

  installPhase = ''
    mkdir -p $out/bin
    cp picat $out/bin/picat
  '';

  meta = with stdenv.lib; {
    description = "Logic-based programming langage";
    homepage    = "http://picat-lang.org/";
    license     = licenses.mpl20;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ earldouglas thoughtpolice ];
  };
}
