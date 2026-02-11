{
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  curl,
  libxml2,
  nix-update-script,
  meta,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "azure-sdk-for-cpp-core";
  version = "1.16.1";
  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-cpp";
    tag = "azure-core_1.16.1";
    hash = "sha256-gMINz3bH80l0QYX3iKJlL962WIMujR1wuN+t4t7g7qg=";
  };
  sourceRoot = "${finalAttrs.src.name}/sdk/core/azure-core";

  postPatch = ''
    sed -i '/CMAKE_CXX_STANDARD/d' CMakeLists.txt
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  propagatedBuildInputs = [
    curl
    libxml2
  ];

  env = {
    AZURE_SDK_DISABLE_AUTO_VCPKG = 1;
  };

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_TRANSPORT_CURL=ON"
    "-DWARNINGS_AS_ERRORS=OFF"
  ];

  postInstall = ''
    moveToOutput "share" "$dev"
    moveToOutput "share/$(basename "$sourceRoot")-cpp/copyright" "$out"
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "azure-core_(.*)"
    ];
  };

  # Testing this is moderately involved, see:
  # https://github.com/Azure/azure-sdk-for-cpp/blob/main/CONTRIBUTING.md#testing-the-project
  # Unless issues arise, it does not seem worth the effort.
  doCheck = false;

  meta = (
    meta
    // {
      description = "Azure SDK Core Library for C++";
      changelog = "https://github.com/Azure/azure-sdk-for-cpp/blob/main/sdk/core/azure-core/CHANGELOG.md";
    }
  );
})
