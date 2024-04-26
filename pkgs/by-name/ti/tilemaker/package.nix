{ lib
, stdenv
, fetchFromGitHub
, buildPackages
, cmake
, installShellFiles
, boost
, lua
, protobuf_21
, rapidjson
, shapelib
, sqlite
, zlib
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tilemaker";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "systemed";
    repo = "tilemaker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rB5oP03yaIzklwkGsIeS9ELbHOY9AObwjRrK9HBQFI4=";
  };

  postPatch = ''
    substituteInPlace src/options_parser.cpp \
      --replace-fail "config.json" "$out/share/tilemaker/config-openmaptiles.json" \
      --replace-fail "process.lua" "$out/share/tilemaker/process-openmaptiles.lua"
    substituteInPlace server/server.cpp \
      --replace-fail "default_value(\"static\")" "default_value(\"$out/share/tilemaker/static\")"
  '';

  nativeBuildInputs = [ cmake installShellFiles ];

  buildInputs = [ boost lua protobuf_21 rapidjson shapelib sqlite zlib ];

  cmakeFlags = lib.optional (stdenv.hostPlatform != stdenv.buildPlatform)
    (lib.cmakeFeature "PROTOBUF_PROTOC_EXECUTABLE" "${buildPackages.protobuf}/bin/protoc");

  env.NIX_CFLAGS_COMPILE = toString [ "-DTM_VERSION=${finalAttrs.version}" ];

  postInstall = ''
    installManPage ../docs/man/tilemaker.1
    install -Dm644 ../resources/*.{json,lua} -t $out/share/tilemaker
    cp -r ../server/static $out/share/tilemaker
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "tilemaker --help";
  };

  meta = with lib; {
    description = "Make OpenStreetMap vector tiles without the stack";
    homepage = "https://tilemaker.org/";
    changelog = "https://github.com/systemed/tilemaker/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = licenses.free; # FTWPL
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
    mainProgram = "tilemaker";
  };
})
