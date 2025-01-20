{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  boost,
  curl,
  cxxopts,
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
    rev = finalAttrs.version;
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
    "-DENABLE_TESTS=OFF"
    "-DENABLE_BENCHMARKS=OFF"
    "-DENABLE_SINGLE_FILES_WERROR=OFF"
    "-DPREFER_EXTERNAL_DEPS=ON"
  ];

  buildInputs = [
    boost
    curl
    cxxopts
    geos
    #howard-hinnant-date
    libspatialite
    luajit
    lz4
    prime-server
    protobuf
    (python3.withPackages (ps: [ ps.pybind11 ]))
    rapidjson
    sqlite
    #unordered_dense
    zeromq
    zlib
  ];

  postFixup = ''
    substituteInPlace "$out"/lib/pkgconfig/libvalhalla.pc \
      --replace '=''${prefix}//' '=/' \
      --replace '=''${exec_prefix}//' '=/'
  '';

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
