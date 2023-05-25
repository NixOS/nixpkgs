{ lib
, stdenv
, fetchFromGitHub
, buildPackages
, cmake
, pkg-config
, substituteAll
, boost
, cairo
, freetype
, gdal
, harfbuzz
, icu
, libjpeg
, libpng
, libtiff
, libwebp
, libxml2
, proj
, python3
, sqlite
, zlib
, catch2
, postgresql
}:

stdenv.mkDerivation rec {
  pname = "mapnik";
  version = "unstable-2022-10-18";

  src = fetchFromGitHub {
    owner = "mapnik";
    repo = "mapnik";
    rev = "05661e54392bcbb3367747f97a3ef6e468c105ba";
    hash = "sha256-96AneLPH1gbh/u880Pdc9OdFq2MniSdaTJoKYqId7sw=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace configure \
      --replace '$PYTHON scons/scons.py' ${buildPackages.scons}/bin/scons
    rm -r scons
  '';

  # a distinct dev output makes python-mapnik fail
  outputs = [ "out" ];

  patches = [
    # The lib/cmake/harfbuzz/harfbuzz-config.cmake file in harfbuzz.dev is faulty,
    # as it provides the wrong libdir. The workaround is to just rely on
    # pkg-config to locate harfbuzz shared object files.
    # Upstream HarfBuzz wants to drop CMake support anyway.
    # See discussion: https://github.com/mapnik/mapnik/issues/4265
    ./cmake-harfbuzz.patch
    # prevent CMake from trying to get libraries on the Internet
    (substituteAll {
      src = ./catch2-src.patch;
      catch2_src = catch2.src;
    })
    ./include.patch
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    boost
    cairo
    freetype
    gdal
    harfbuzz
    icu
    libjpeg
    libpng
    libtiff
    libwebp
    proj
    python3
    sqlite
    zlib
    libxml2
    postgresql
  ];

  cmakeFlags = [
    # Would require qt otherwise.
    "-DBUILD_DEMO_VIEWER=OFF"
  ];

  # mapnik-config is currently not build with CMake. So we use the SCons for
  # this one. We can't add SCons to nativeBuildInputs though, as stdenv would
  # then try to build everything with scons.
  preBuild = ''
    cd ..
    ${buildPackages.scons}/bin/scons utils/mapnik-config
    cd build
  '';

  preInstall = ''
    mkdir -p $out/bin
    cp ../utils/mapnik-config/mapnik-config $out/bin/mapnik-config
  '';

  meta = with lib; {
    description = "An open source toolkit for developing mapping applications";
    homepage = "https://mapnik.org";
    maintainers = with maintainers; [ hrdinka ];
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
  };
}
