{ stdenv, fetchurl, libunwind }:

stdenv.mkDerivation rec {
  name = "gperftools-2.5";

  src = fetchurl {
    url = "https://github.com/gperftools/gperftools/releases/download/${name}/${name}.tar.gz";
    sha256 = "0wsix3lhkpjv8lxmcbml549mfwifdv7n1qak09slvx6d3a7p98kg";
  };

  buildInputs = stdenv.lib.optional stdenv.isLinux libunwind;

  prePatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile.am --replace stdc++ c++
    substituteInPlace Makefile.in --replace stdc++ c++
    substituteInPlace libtool --replace stdc++ c++
  '';

  # some packages want to link to the static tcmalloc_minimal
  # to drop the runtime dependency on gperftools
  dontDisableStatic = true;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://code.google.com/p/gperftools/;
    description = "Fast, multi-threaded malloc() and nifty performance analysis tools";
    platforms = with platforms; linux ++ darwin;
    license = licenses.bsd3;
    maintainers = with maintainers; [ vcunat wkennington ];
  };
}
