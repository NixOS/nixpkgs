{ stdenv, fetchFromGitHub, unzip, openexr, boost, jemalloc, c-blosc, ilmbase, tbb }:

stdenv.mkDerivation rec
{
  pname = "openvdb";
  version = "6.2.1";

  src = fetchFromGitHub {
    owner = "dreamworksanimation";
    repo = "openvdb";
    rev = "v${version}";
    sha256 = "1ypkzdkgsbcczfvrqblnxfzm13w0mdkskgqmgvmbfi66vpaazdrf";
  };

  outputs = [ "out" ];

  buildInputs = [ unzip openexr boost tbb jemalloc c-blosc ilmbase ];

  setSourceRoot = ''
    sourceRoot=$(echo */openvdb)
  '';

  installTargets = [ "install_lib" ];

  enableParallelBuilding = true;

  buildFlags = [
    "lib"
    "DESTDIR=$(out)"
    "HALF_LIB=-lHalf"
    "TBB_LIB=-ltbb"
    "BLOSC_LIB=-lblosc"
    "LOG4CPLUS_LIB="
    "BLOSC_INCLUDE_DIR=${c-blosc}/include/"
    "BLOSC_LIB_DIR=${c-blosc}/lib/"
  ];

  installFlags = [ "DESTDIR=$(out)" ];

  NIX_CFLAGS_COMPILE="-I${openexr.dev}/include/OpenEXR -I${ilmbase.dev}/include/OpenEXR/";
  NIX_LDFLAGS="-lboost_iostreams";

  meta = with stdenv.lib; {
    description = "An open framework for voxel";
    homepage = "https://www.openvdb.org";
    maintainers = [ maintainers.guibou ];
    platforms = platforms.linux;
    license = licenses.mpl20;
  };
}
