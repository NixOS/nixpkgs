{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  buildPackages,
  cmake,
  pkg-config,
  boost,
  cairo,
  freetype,
  gdal,
  harfbuzz,
  icu,
  libjpeg,
  libpng,
  libtiff,
  libwebp,
  libxml2,
  proj,
  python3,
  sqlite,
  zlib,
  catch2,
  postgresql,
  protozero,
  sparsehash,
}:

stdenv.mkDerivation rec {
  pname = "mapnik";
  version = "4.0.4";

  src = fetchFromGitHub {
    owner = "mapnik";
    repo = "mapnik";
    rev = "v${version}";
    hash = "sha256-CuLdhLh0S92tK/tKeLzG23H3Iiy+z/XwCS+q84FsZZo=";
    fetchSubmodules = true;
  };

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  postPatch = ''
    substituteInPlace configure \
      --replace '$PYTHON scons/scons.py' ${buildPackages.scons}/bin/scons
    rm -r scons
    # Remove bundled 'sparsehash' directory in favor of 'sparsehash' package
    rm -r deps/mapnik/sparsehash
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
    # Account for full paths when generating libmapnik.pc
    ./export-pkg-config-full-paths.patch
    # Use 'sparsehash' package.
    ./use-sparsehash-package.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

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
    protozero
    sparsehash
  ];

  cmakeFlags = [
    # Save time by not building some development-related code.
    (lib.cmakeBool "BUILD_BENCHMARK" false)
    (lib.cmakeBool "BUILD_DEMO_CPP" false)
    ## Would require QT otherwise.
    (lib.cmakeBool "BUILD_DEMO_VIEWER" false)
    # Use 'protozero' package.
    (lib.cmakeBool "USE_EXTERNAL_MAPBOX_PROTOZERO" true)
    # macOS builds fail when using memory mapped file cache.
    (lib.cmakeBool "USE_MEMORY_MAPPED_FILE" (!stdenv.hostPlatform.isDarwin))
    # don't try to download sources for catch2, use our own
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_CATCH2" "${catch2.src}")
  ];

  doCheck = true;

  # mapnik-config is currently not build with CMake. So we use the SCons for
  # this one. We can't add SCons to nativeBuildInputs though, as stdenv would
  # then try to build everything with scons. C++17 is the minimum supported
  # C++ version.
  preBuild = ''
    cd ..
    env CXX_STD=17 ${buildPackages.scons}/bin/scons utils/mapnik-config
    cd build
  '';

  preInstall = ''
    mkdir -p $out/bin
    cp ../utils/mapnik-config/mapnik-config $out/bin/mapnik-config
  '';

  meta = with lib; {
    description = "Open source toolkit for developing mapping applications";
    homepage = "https://mapnik.org";
    maintainers =
      with maintainers;
      teams.geospatial.members
      ++ [
        hrdinka
        hummeltech
      ];
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
  };
}
