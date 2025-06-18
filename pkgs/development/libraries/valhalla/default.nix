{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  boost,
  curl,
  cxxopts,
  gdal,
  geos,
  libspatialite,
  luajit,
  lz4,
  prime-server,
  protobuf,
  python3,
  rapidjson,
  sqlite,
  zeromq,
  zlib,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "valhalla";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "valhalla";
    repo = "valhalla";
    tag = finalAttrs.version;
    hash = "sha256-v/EwoJA1j8PuF9jOsmxQL6i+MT0rXbyLUE4HvBHUWDo=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace src/bindings/python/CMakeLists.txt \
      --replace-fail "\''${Python_SITEARCH}" "${placeholder "out"}/${python3.sitePackages}"
    substituteInPlace CMakeLists.txt \
      --replace-fail "rapidjson_include_dir rapidjson" "rapidjson_include_dir RapidJSON"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "ENABLE_TESTS" false)
    (lib.cmakeBool "ENABLE_SINGLE_FILES_WERROR" false)
    (lib.cmakeBool "PREFER_EXTERNAL_DEPS" true)
  ];

  buildInputs = [
    boost
    cxxopts
    lz4
    (python3.withPackages (ps: [ ps.pybind11 ]))
    rapidjson
    zeromq
  ];

  propagatedBuildInputs = [
    curl
    gdal
    geos
    libspatialite
    luajit
    prime-server
    protobuf
    sqlite
    zlib
  ];

  passthru.tests = {
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = with lib; {
    changelog = "https://github.com/valhalla/valhalla/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Open Source Routing Engine for OpenStreetMap";
    homepage = "https://valhalla.readthedocs.io/";
    license = licenses.mit;
    maintainers = [ maintainers.Thra11 ];
    pkgConfigModules = [ "libvalhalla" ];
    platforms = platforms.linux;
  };
})
