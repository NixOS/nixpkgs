{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPackages,
  cmake,
  boost,
  lua,
  protobuf_21,
  rapidjson,
  shapelib,
  sqlite,
  zlib,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tilemaker";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "systemed";
    repo = "tilemaker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0reO4YYxbFM75CQrSLTybsb5g6PhJaShAtT+X3CaPfM=";
  };

  postPatch = ''
    substituteInPlace src/options_parser.cpp \
      --replace-fail "config.json" "$out/share/tilemaker/config-openmaptiles.json" \
      --replace-fail "process.lua" "$out/share/tilemaker/process-openmaptiles.lua"
    substituteInPlace server/server.cpp \
      --replace-fail "default_value(\"static\")" "default_value(\"$out/share/tilemaker/static\")"
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    lua
    protobuf_21
    rapidjson
    shapelib
    sqlite
    zlib
  ];

  cmakeFlags = lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) (
    lib.cmakeFeature "PROTOBUF_PROTOC_EXECUTABLE" "${buildPackages.protobuf}/bin/protoc"
  );

  env.NIX_CFLAGS_COMPILE = toString [ "-DTM_VERSION=${finalAttrs.version}" ];

  postInstall = ''
    install -Dm644 ../resources/*.{json,lua} -t $out/share/tilemaker
    cp -r ../server/static $out/share/tilemaker
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Make OpenStreetMap vector tiles without the stack";
    homepage = "https://tilemaker.org/";
    changelog = "https://github.com/systemed/tilemaker/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.free; # FTWPL
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
    mainProgram = "tilemaker";
  };
})
