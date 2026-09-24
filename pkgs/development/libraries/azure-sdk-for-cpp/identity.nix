{
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  openssl,
  core,
  nix-update-script,
  meta,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "azure-sdk-for-cpp-identity";
  version = "1.13.3";
  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-cpp";
    tag = "azure-identity_${finalAttrs.version}";
    hash = "sha256-IGhJi8fnNY/NXnZ6ZGclJxG1gEx7BRj9setMaFUJZNQ=";
  };
  sourceRoot = "${finalAttrs.src.name}/sdk/identity/azure-identity";

  postPatch = ''
    sed -i '/CMAKE_CXX_STANDARD/d' CMakeLists.txt
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [ openssl ];
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
      "azure-identity_(.*)"
    ];
  };

  meta = (
    meta
    // {
      description = "Azure Identity client library for C++";
      changelog = "https://github.com/Azure/azure-sdk-for-cpp/blob/main/sdk/identity/azure-identity/CHANGELOG.md";
    }
  );
})
