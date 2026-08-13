{
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  core,
  opentelemetry-cpp,
  nix-update-script,
  meta,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "azure-sdk-for-cpp-core-tracing-opentelemetry";
  version = "1.0.0-beta.4";
  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-cpp";
    tag = "azure-core-tracing-opentelemetry_1.0.0-beta.4";
    hash = "sha256-3PqHpoi7zlTUYJ4A4APKp2yPg9nVwgGiyOZ+bng4Crk=";
  };
  sourceRoot = "${finalAttrs.src.name}/sdk/core/azure-core-tracing-opentelemetry";

  postPatch = ''
    sed -i '/CMAKE_CXX_STANDARD/d' CMakeLists.txt
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [ opentelemetry-cpp ];
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
      "azure-core-tracing-opentelemetry_(.*)"
    ];
  };

  meta = (
    meta
    // {
      description = "Azure SDK Core Tracing Library for C++";
      changelog = "https://github.com/Azure/azure-sdk-for-cpp/blob/main/sdk/core/azure-core-tracing-opentelemetry/CHANGELOG.md";
    }
  );
})
