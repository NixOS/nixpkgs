{
  stdenv,
  cmake,
  ninja,
  storage-common,
  fetchFromGitHub,
  nix-update-script,
  meta,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "azure-sdk-for-cpp-storage-queues";
  version = "12.6.0";
  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-cpp";
    tag = "azure-storage-queues_${finalAttrs.version}";
    hash = "sha256-cycBXSvc3G8TdLnI4Ht1lBd9ndPOjxWFQA54a24iUsY=";
  };
  sourceRoot = "${finalAttrs.src.name}/sdk/storage/azure-storage-queues";

  postPatch = ''
    sed -i '/CMAKE_CXX_STANDARD/d' CMakeLists.txt
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  propagatedBuildInputs = [ storage-common ];

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
      "azure-storage-queues_(.*)"
    ];
  };

  meta = (
    meta
    // {
      description = "Azure Storage Queues Client Library for C++";
      changelog = "https://github.com/Azure/azure-sdk-for-cpp/blob/main/sdk/storage/azure-storage-queues/CHANGELOG.md";
    }
  );
})
