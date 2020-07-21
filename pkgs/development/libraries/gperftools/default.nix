{ stdenv, fetchurl, libunwind }:

stdenv.mkDerivation rec {
  name = "gperftools-2.8";

  src = fetchurl {
    url = "https://github.com/gperftools/gperftools/releases/download/${name}/${name}.tar.gz";
    sha256 = "0gjiplvday50x695pwjrysnvm5wfvg2b0gmqf6b4bdi8sv6yl394";
  };

  # tcmalloc uses libunwind in a way that works correctly only on non-ARM linux
  buildInputs = stdenv.lib.optional (stdenv.isLinux && !(stdenv.isAarch64 || stdenv.isAarch32)) libunwind;

  prePatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile.am --replace stdc++ c++
    substituteInPlace Makefile.in --replace stdc++ c++
    substituteInPlace libtool --replace stdc++ c++
  '';

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.isDarwin
    "-D_XOPEN_SOURCE -Wno-aligned-allocation-unavailable";

  # some packages want to link to the static tcmalloc_minimal
  # to drop the runtime dependency on gperftools
  dontDisableStatic = true;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/gperftools/gperftools";
    description = "Fast, multi-threaded malloc() and nifty performance analysis tools";
    platforms = with platforms; linux ++ darwin;
    license = licenses.bsd3;
    maintainers = with maintainers; [ vcunat ];
  };
}
