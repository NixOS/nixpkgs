{
  lib,
  stdenv,
  fetchFromGitHub,
  apple-sdk,
  macro-utils-c,
  umock-c,
  cmake,
  ninja,
  pkg-config,
  curl,
  openssl,
}:
stdenv.mkDerivation {
  pname = "azure-c-shared-utility";
  # Same version as in VCPKG as of July 2025.
  # https://github.com/microsoft/vcpkg/blob/master/ports/azure-c-shared-utility/portfile.cmake
  version = "LTS_07_2022_Ref02-unstable-2025-03-31";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-c-shared-utility";
    rev = "772a4f8bc338140b4a0f404cf9c344283c5c937f";
    hash = "sha256-NSgY7EQhqR01s00mwgLJFMi8salbsCoAG2PMFrONBGk=";
  };

  # Using the cmake target instead of the variable correctly propagates
  # transitive dependencies when using static libraries.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${CURL_LIBRARIES}" "CURL::libcurl"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];
  buildInputs = [
    macro-utils-c
    umock-c
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin apple-sdk;
  propagatedBuildInputs = [ curl ] ++ lib.optional (!stdenv.hostPlatform.isDarwin) openssl;

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-Duse_default_uuid=ON"
    "-Duse_installed_dependencies=ON"
  ];

  env = {
    NIX_CFLAGS_COMPILE = "-Wno-error";
  };

  postInstall = ''
    mkdir $out/include/azureiot
  '';

  meta = {
    homepage = "https://github.com/Azure/azure-c-shared-utility";
    description = "Azure C SDKs common code";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.tobim ];
    platforms = lib.platforms.all;
  };
}
