{
  generateProtobufCode,
  version,
  zitadelRepo,
}:

{
  lib,
  stdenv,
  pnpm,
  nodejs,
  grpc-gateway,
  protoc-gen-connect-go,
  protoc-gen-grpc-web,
  buf,
  fetchFromGitHub,
  pkg-config,
  protobuf_27,
}:

let
  protoc-gen-js = stdenv.mkDerivation (finalAttrs: {
    pname = "protoc-gen-js";
    version = "3.21.4";

    src = fetchFromGitHub {
      owner = "protocolbuffers";
      repo = "protobuf-javascript";
      rev = "v${finalAttrs.version}";
      hash = "sha256-eIOtVRnHv2oz4xuVc4aL6JmhpvlODQjXHt1eJHsjnLg=";
    };

    nativeBuildInputs = [
      pkg-config
      stdenv.cc
    ];

    buildInputs = [
      protobuf_27
      protobuf_27.passthru.abseil-cpp
    ];

    doCheck = false;

    buildPhase = ''
      runHook preBuild

      $CXX -std=c++17 \
        -I. \
        $(pkg-config --cflags protobuf) \
        generator/*.cc \
        -o protoc-gen-js \
        $(pkg-config --libs protobuf) \
        -lprotoc

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -Dm755 protoc-gen-js $out/bin/protoc-gen-js

      runHook postInstall
    '';
  });

  protobufGenerated = generateProtobufCode {
    pname = "zitadel-console";
    inherit version;
    nativeBuildInputs = [
      grpc-gateway
      protoc-gen-connect-go
      protoc-gen-grpc-web
      protoc-gen-js
    ];
    workDir = "console";
    bufArgs = "../proto --include-imports --include-wkt";
    outputPath = "src/app/proto";
    hash = "sha256-Bv0wlGOUpb2y5mU2Z1fj5RO5oBmyJ704A3FNzO++pFE=";
  };

  zitadelProtobufGenerated = generateProtobufCode {
    pname = "zitadel-proto";
    inherit version;
    workDir = "packages/zitadel-proto";
    bufArgs = "../../proto";
    outputPath = ".";
    hash = "sha256-baPS1wbsUQzelI55zswTPvX7ojXbPts967lwgcZGvlE=";
  };

  client = stdenv.mkDerivation (finalAttrs: {
    pname = "zitadel-client";
    inherit version;
    src = zitadelRepo;

    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 2;
      hash = "sha256-53G8vWbaFDFufh3KLGq+KzrHB4CEICElkMCGudDHYcc=";
    };

    pnpmWorkspaces = [
      "@zitadel/proto"
      "@zitadel/client"
    ];

    nativeBuildInputs = [
      pnpm.configHook
      nodejs
      buf
    ];

    preBuild = ''
      cp -r ${zitadelProtobufGenerated}/{cjs,es,types} packages/zitadel-proto
    '';

    buildPhase = ''
      runHook preBuild
      pnpm --filter=@zitadel/client run build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r packages/zitadel-client/dist "$out"
      runHook postInstall
    '';
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "zitadel-console";
  inherit version;

  src = zitadelRepo;

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-53G8vWbaFDFufh3KLGq+KzrHB4CEICElkMCGudDHYcc=";
  };

  pnpmWorkspaces = [
    "@zitadel/proto"
    "@zitadel/client"
    "console"
  ];

  nativeBuildInputs = [
    pnpm.configHook
    nodejs
    buf
  ];

  preBuild = ''
    cp -r ${protobufGenerated} console/src/app/proto
    cp -r ${zitadelProtobufGenerated}/{cjs,es,types} packages/zitadel-proto
    cp -r ${client} packages/zitadel-client/dist
  '';

  buildPhase = ''
    runHook preBuild

    pnpm --filter=console build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r console/dist/console "$out"

    runHook postInstall
  '';
})
