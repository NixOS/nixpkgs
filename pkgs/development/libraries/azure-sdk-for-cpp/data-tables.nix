{
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  core,
  openssl,
  libxml2,
  nix-update-script,
  meta,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "azure-sdk-for-cpp-data-tables";
  version = "1.0.0-beta.6";
  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-cpp";
    tag = "azure-data-tables_1.0.0-beta.6";
    hash = "sha256-gfkjoA16UP6ToIueYPfhQFh+LEhlVtvTk3qRJoHR5OY=";
  };
  sourceRoot = "${finalAttrs.src.name}/sdk/tables/azure-data-tables";

  postPatch = ''
    sed -i '/CMAKE_CXX_STANDARD/d' CMakeLists.txt
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    openssl
    libxml2
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
      "azure-data-tables_(.*)"
    ];
  };

  meta = (
    meta
    // {
      description = "Azure Tables client library for C++";
      changelog = "https://github.com/Azure/azure-sdk-for-cpp/blob/main/sdk/tables/azure-data-tables/CHANGELOG.md";
    }
  );
})
