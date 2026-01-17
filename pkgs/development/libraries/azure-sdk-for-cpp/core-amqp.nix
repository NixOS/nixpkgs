{
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  core,
  c-shared-utility,
  macro-utils-c,
  umock-c,
  nix-update-script,
  meta,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "azure-sdk-for-cpp-core-amqp";
  version = "1.0.0-beta.11";
  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-cpp";
    tag = "azure-core-amqp_1.0.0-beta.11";
    hash = "sha256-MQsz5Dmv1BwfUaN1VXMC3hPdMHihlgOBaukp5wgTNJc=";
  };
  sourceRoot = "${finalAttrs.src.name}/sdk/core/azure-core-amqp";

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
    c-shared-utility
    macro-utils-c
    umock-c
  ];

  env = {
    AZURE_SDK_DISABLE_AUTO_VCPKG = 1;
    NIX_CFLAGS_COMPILE = "-Wno-error";
  };

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DDISABLE_RUST_IN_BUILD=ON"
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
      "azure-core-amqp_(.*)"
    ];
  };

  meta = (
    meta
    // {
      description = "Azure SDK AMQP Library for C++";
      changelog = "https://github.com/Azure/azure-sdk-for-cpp/blob/main/sdk/core/azure-core-amqp/CHANGELOG.md";
    }
  );
})
