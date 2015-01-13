{ stdenv, fetchurl, unzip, libunwind }:

stdenv.mkDerivation rec {
  name = "gperftools-2.3";

  src = fetchurl {
    url = "https://googledrive.com/host/0B6NtGsLhIcf7MWxMMF9JdTN3UVk/gperftools-2.3.zip";
    sha256 = "0yga56kmlf5gwr3ip7l50qlv2d3ygbyhpl7pnbx4r905qd59k3qs";
  };

  buildInputs = [ unzip ] ++ stdenv.lib.optional stdenv.isLinux libunwind;

  # some packages want to link to the static tcmalloc_minimal
  # to drop the runtime dependency on gperftools
  dontDisableStatic = true;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://code.google.com/p/gperftools/;
    description = "Fast, multi-threaded malloc() and nifty performance analysis tools";
    platforms = with platforms; linux ++ darwin;
    license = licenses.bsd3;
    maintainers = with maintainers; [ wkennington ];
  };
}
