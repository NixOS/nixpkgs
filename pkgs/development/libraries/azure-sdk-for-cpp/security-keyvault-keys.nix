{
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  core,
  nix-update-script,
  meta,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "azure-sdk-for-cpp-keyvault-keys";
  version = "4.5.0-beta.3";
  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-cpp";
    tag = "azure-security-keyvault-keys_4.5.0-beta.3";
    hash = "sha256-NSstk0cpgWBOhi50eiFSHDYiJjel2a4l8xxgfIPKSsU=";
  };
  sourceRoot = "${finalAttrs.src.name}/sdk/keyvault/azure-security-keyvault-keys";

  postPatch = ''
    sed -i '/CMAKE_CXX_STANDARD/d' CMakeLists.txt
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  propagatedBuildInputs = [ core ];

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
      "azure-keyvault-keys_(.*)"
    ];
  };

  meta = (
    meta
    // {
      description = "Azure Key Vault Key client library for C++";
      changelog = "https://github.com/Azure/azure-sdk-for-cpp/blob/main/sdk/keyvault/azure-security-keyvault-keys/CHANGELOG.md";
    }
  );
})
