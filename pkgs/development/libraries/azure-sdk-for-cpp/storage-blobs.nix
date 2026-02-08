{
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  storage-common,
  nix-update-script,
  meta,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "azure-sdk-for-cpp-storage-blobs";
  version = "12.15.0";
  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-cpp";
    tag = "azure-storage-blobs_12.15.0";
    hash = "sha256-u+zaMoX64GcTKE7QIF5WyENTogLBMTCenoI8hPY7m08=";
  };
  sourceRoot = "${finalAttrs.src.name}/sdk/storage/azure-storage-blobs";

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
      "azure-storage-blobs_(.*)"
    ];
  };

  meta = (
    meta
    // {
      description = "Azure Storage Blobs Client Library for C++";
      changelog = "https://github.com/Azure/azure-sdk-for-cpp/blob/main/sdk/storage/azure-storage-blobs/CHANGELOG.md";
    }
  );
})
