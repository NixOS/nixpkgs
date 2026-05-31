{
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  core,
  messaging-eventhubs,
  storage-blobs,
  nix-update-script,
  meta,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "azure-sdk-for-cpp-messaging-eventhubs-checkpointstore-blob";
  version = "1.0.0-beta.1";
  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-cpp";
    tag = "azure-messaging-eventhubs-checkpointstore-blob_1.0.0-beta.1";
    hash = "sha256-487IwzlxnKd09ztf9NQESbp/kZzsT18JXKgMwsG5W/Y=";
  };
  sourceRoot = "${finalAttrs.src.name}/sdk/eventhubs/azure-messaging-eventhubs-checkpointstore-blob";

  postPatch = ''
    sed -i '/CMAKE_CXX_STANDARD/d' CMakeLists.txt
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  propagatedBuildInputs = [
    core
    messaging-eventhubs
    storage-blobs
  ];

  env = {
    AZURE_SDK_DISABLE_AUTO_VCPKG = 1;
  };

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DWARNINGS_AS_ERRORS=OFF"
  ];

  postInstall = ''
    moveToOutput "share" "$dev"
    moveToOutput "share/$(basename "$sourceRoot")-cpp/copyright" "$out"
  '';

  # See note in ./core.nix.
  doCheck = false;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "azure-messaging-eventhubs-checkpointstore-blob_(.*)"
    ];
  };

  meta = (
    meta
    // {
      description = "Azure Event Hubs Blob Storage Checkpoint Store for C++";
      changelog = "https://github.com/Azure/azure-sdk-for-cpp/blob/main/sdk/eventhubs/azure-messaging-eventhubs-checkpointstore-blob/CHANGELOG.md";
    }
  );
})
