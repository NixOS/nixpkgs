{ stdenv
, fetchurl
, cmake
, mpi
}:

stdenv.mkDerivation rec {
  name = "parmetis-${version}";
  version = "4.0.3";

  src = fetchurl {
    url = "http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/parmetis-${version}.tar.gz";
    sha256 = "0pvfpvb36djvqlcc3lq7si0c5xpb2cqndjg8wvzg35ygnwqs5ngj";
  };

  buildInputs = [ cmake mpi ];

  # metis and GKlib are packaged with distribution
  # AUR https://aur.archlinux.org/packages/parmetis/ has reported that
  # it easier to build with the included packages as opposed to using the metis
  # package. Compilation time is short.
  configurePhase = ''
    make config metis_path=$PWD/metis gklib_path=$PWD/metis/GKlib prefix=$out
  '';

  meta = with stdenv.lib; {
    description = "ParMETIS is an MPI-based parallel library that implements a variety of algorithms for partitioning unstructured graphs, meshes, and for computing fill-reducing orderings of sparse matrices";
    homepage = http://glaros.dtc.umn.edu/gkhome/metis/parmetis/overview;
    platforms = platforms.all;
    license = licenses.unfree;
    maintainers = [ maintainers.costrouc ];
  };
}
