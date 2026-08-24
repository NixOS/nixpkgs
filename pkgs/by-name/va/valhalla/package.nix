{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  boost,
  curl,
  cxxopts,
  expat,
  geos,
  libgeotiff,
  libspatialite,
  libtiff,
  luajit,
  lz4,
  openssl,
  prime-server,
  protobuf,
  python3,
  rapidjson,
  spatialite-tools,
  sqlite,
  zeromq,
  zlib,
  testers,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "valhalla";
  version = "3.8.3";

  src = fetchFromGitHub {
    owner = "valhalla";
    repo = "valhalla";
    tag = finalAttrs.version;
    hash = "sha256-wWiiadJqoZylV2YK+mu+cQBfd597id39RQgwaQDtvW4=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace src/bindings/python/CMakeLists.txt \
      --replace-fail "\''${Python_SITEARCH}" "${placeholder "out"}/${python3.sitePackages}"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    spatialite-tools
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "ENABLE_TESTS" false)
    (lib.cmakeBool "ENABLE_SINGLE_FILES_WERROR" false)
    (lib.cmakeBool "PREFER_EXTERNAL_DEPS" true)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # On darwin Valhalla only looks at the Homebrew paths
    (lib.cmakeFeature "SQLITE3_INCLUDE_DIR" "${lib.getDev sqlite}/include")
    (lib.cmakeFeature "SQLITE3_LIBRARY" "${lib.getLib sqlite}/lib/libsqlite3.dylib")
  ];

  buildInputs = [
    boost
    cxxopts
    expat
    libgeotiff
    libtiff
    lz4
    openssl
    python3
    rapidjson
    zeromq
  ];

  propagatedBuildInputs = [
    curl
    geos
    libspatialite
    luajit
    prime-server
    protobuf
    sqlite
    zlib
  ];

  passthru = {
    tests = {
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/valhalla/valhalla/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Open Source Routing Engine for OpenStreetMap";
    homepage = "https://valhalla.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Thra11
      karlbeecken
    ];
    pkgConfigModules = [ "libvalhalla" ];
    platforms = lib.platforms.unix;
  };
})
