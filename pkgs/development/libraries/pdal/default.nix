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
, proj
, tiledb
, xercesc
, zlib
, zstd
}:

stdenv.mkDerivation rec {
  pname = "pdal";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "PDAL";
    repo = "PDAL";
    rev = version;
    sha256 = "sha256-ivr5vAlbFjikviz0oAbFH0AJlM4Tv+WE88AeNSf47RM=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/PDAL/PDAL/commit/6320e8832e40d9a5f92af619aaaf05169226de1a.diff";
      hash = "sha256-EG51+SARZJ0DWYMWRG1Z/ukWDxOS0D5AHp8yawfOJxs=";
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
    libgeotiff
    libtiff
    libxml2
    postgresql
    proj
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

    # https://github.com/PDAL/PDAL/issues/4211
    # Once merged, https://github.com/PDAL/PDAL/pull/4267 might provide better
    # solution for #4211.
    "-DWITH_BACKTRACE=OFF"

    "-DWITH_COMPLETION=ON"
  ];

  # https://github.com/OSGeo/grass/issues/3220
  postInstall = ''
    rm $out/lib/libpdalcpp.so
    ln -rs $out/lib/libpdalcpp.so.?? $out/lib/libpdalcpp.so
  '';

  meta = with lib; {
    description = "PDAL is Point Data Abstraction Library. GDAL for point cloud data";
    homepage = "https://pdal.io";
    license = licenses.bsd3;
    maintainers = teams.geospatial.members;
    platforms = platforms.all;
  };
}
