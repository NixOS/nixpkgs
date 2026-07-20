{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  macro-utils-c,
}:
stdenv.mkDerivation {
  pname = "azure-umock-c";
  # Same version as in VCPKG as of February 2025.
  # https://github.com/microsoft/vcpkg/blob/master/ports/umock-c/portfile.cmake
  version = "1.1.0-unstable-2022-01-21";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "umock-c";
    rev = "504193e65d1c2f6eb50c15357167600a296df7ff";
    hash = "sha256-oeqsy63G98c4HWT6NtsYzC6/YxgdROvUe9RAdmElbCM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];
  buildInputs = [ macro-utils-c ];

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-Duse_installed_dependencies=ON"
  ];

  meta = {
    homepage = "https://github.com/Azure/umock-c";
    description = "Pure C mocking library";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.tobim ];
    platforms = lib.platforms.all;
  };
}
