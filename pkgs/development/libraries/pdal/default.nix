{ stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
# , openscenegraph
, curl
, gdal
, hdf5-cpp
, LASzip
, libe57format
, libgeotiff
, libxml2
, postgresql
, tiledb
, xercesc
, zlib
, zstd
}:

stdenv.mkDerivation rec {
  pname = "pdal";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "PDAL";
    repo = "PDAL";
    rev = version;
    sha256 = "0zb3zjqgmjjryb648c1hmwh1nfa7893bjzbqpmr6shjxvzgnj9p6";
  };

  patches = [
    # Fix duplicate paths like
    #     /nix/store/7iafqfmjdlxqim922618wg87cclrpznr-PDAL-2.1.0//nix/store/7iafqfmjdlxqim922618wg87cclrpznr-PDAL-2.1.0/lib
    # similar to https://github.com/NixOS/nixpkgs/pull/82654.
    # TODO Remove on release > 2.1.0
    (fetchpatch {
      name = "pdal-Fixup-install-config.patch";
      url = "https://github.com/PDAL/PDAL/commit/2f887ef624db50c6e20f091f34bb5d3e65b5c5c8.patch";
      sha256 = "0pdw9v5ypq7w9i7qzgal110hjb9nqi386jvy3x2h4vf1dyalzid8";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    # openscenegraph
    curl
    gdal
    hdf5-cpp
    LASzip
    libe57format
    libgeotiff
    libxml2
    postgresql
    tiledb
    xercesc
    zlib
    zstd
  ];

  cmakeFlags = [
    "-DBUILD_PLUGIN_E57=ON"
    "-DBUILD_PLUGIN_HDF=ON"
    "-DBUILD_PLUGIN_PGPOINTCLOUD=ON"
    "-DBUILD_PLUGIN_TILEDB=ON"

    # Plugins that can probably be made working relatively easily:
    # As of writing, seems to be incompatible (build error):
    #     error: no matching function for call to 'osg::TriangleFunctor<pdal::CollectTriangles>::operator()(const Vec3&, const Vec3&, const Vec3&)'
    "-DBUILD_PLUGIN_OPENSCENEGRAPH=OFF" # requires OpenGL

    # Plugins can probably not be made work easily:
    "-DBUILD_PLUGIN_CPD=OFF"
    "-DBUILD_PLUGIN_FBX=OFF" # Autodesk FBX SDK is gratis+proprietary; not packaged in nixpkgs
    "-DBUILD_PLUGIN_GEOWAVE=OFF"
    "-DBUILD_PLUGIN_I3S=OFF"
    "-DBUILD_PLUGIN_ICEBRIDGE=OFF"
    "-DBUILD_PLUGIN_MATLAB=OFF"
    "-DBUILD_PLUGIN_MBIO=OFF"
    "-DBUILD_PLUGIN_MRSID=OFF"
    "-DBUILD_PLUGIN_NITF=OFF"
    "-DBUILD_PLUGIN_OCI=OFF"
    "-DBUILD_PLUGIN_RDBLIB=OFF" # Riegl rdblib is proprietary; not packaged in nixpkgs
    "-DBUILD_PLUGIN_RIVLIB=OFF"
  ];

  meta = with stdenv.lib; {
    description = "PDAL is Point Data Abstraction Library. GDAL for point cloud data.";
    homepage = "https://pdal.io";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nh2 ];
    platforms = platforms.all;
  };
}
