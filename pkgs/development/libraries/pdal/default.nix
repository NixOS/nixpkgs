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
, enableE57 ? lib.meta.availableOn stdenv.hostPlatform libe57format
, libe57format
, libgeotiff
, libtiff
, libxml2
, postgresql
, tiledb
, xercesc
, zlib
, zstd
}:

stdenv.mkDerivation rec {
  pname = "pdal";
<<<<<<< HEAD
  version = "2.5.6";
=======
  version = "2.4.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "PDAL";
    repo = "PDAL";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-JKwa89c05EfZ/FxOkj8lYmw0o2EgSqafRDIV2mTpZ5E=";
=======
    sha256 = "sha256-9TQlhuGSTnHsTlJos9Hwnyl1CxI0tXLZdqsaGdp6WIE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

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
    libgeotiff
    libtiff
    libxml2
    postgresql
    tiledb
    xercesc
    zlib
    zstd
  ] ++ lib.optionals enableE57 [
    libe57format
  ];

  cmakeFlags = [
    "-DBUILD_PLUGIN_E57=${if enableE57 then "ON" else "OFF"}"
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
<<<<<<< HEAD
    maintainers = teams.geospatial.members;
=======
    maintainers = with maintainers; [ nh2 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.all;
  };
}
