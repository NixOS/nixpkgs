{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, openscenegraph
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
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "PDAL";
    repo = "PDAL";
    rev = version;
    sha256 = "sha256-DKIraCyp8fcgnVp5dFrtQ4Wq96cQGC9SiAPLS6htUZc=";
  };

  patches = [
    # fix build with GCC 11
    (fetchpatch {
      url = "https://github.com/PDAL/PDAL/commit/47e1eb2dc884d1b8c5caa8e3b48ef90f4f12c68d.patch";
      hash = "sha256-Ls2LkVpbwQAMt2Iuq0zq9D9l2eyP8m1IO3poCnbxGDU=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    openscenegraph
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

  meta = with lib; {
    description = "PDAL is Point Data Abstraction Library. GDAL for point cloud data";
    homepage = "https://pdal.io";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nh2 ];
    platforms = platforms.all;
  };
}
