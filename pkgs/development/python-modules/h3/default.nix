{
  autoPatchelfHook,
  buildPythonPackage,
  cmake,
  cython,
  fetchFromGitHub,
  h3,
  lib,
  ninja,
  numpy,
  pytestCheckHook,
  pytest-cov-stub,
  scikit-build-core,
  stdenv,
}:

buildPythonPackage rec {
  pname = "h3";
  version = "4.3.1";
  pyproject = true;

  # pypi version does not include tests
  src = fetchFromGitHub {
    owner = "uber";
    repo = "h3-py";
    tag = "v${version}";
    hash = "sha256-zt7zbBgSp2P9q7mObZeQZpW9Szip62dAYdPZ2cGTmi4=";
  };

  dontConfigure = true;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  build-system = [
    scikit-build-core
    cmake
    cython
    ninja
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # On Linux the .so files ends up referring to libh3.so instead of the full
    # Nix store path. I'm not sure why this is happening! On Darwin it works
    # fine.
    autoPatchelfHook
  ];

  # This is not needed per-se, it's only added for autoPatchelfHook to work
  # correctly. See the note above ^^
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ h3 ];

  dependencies = [ numpy ];

  # The following prePatch replaces the h3lib compilation with using the h3 packaged in nixpkgs.
  #
  # - Remove the h3lib submodule.
  # - Patch CMakeLists to avoid building h3lib, and use h3 instead.
  prePatch =
    let
      cmakeCommands = ''
        include_directories(${lib.getDev h3}/include/h3)
        link_directories(${h3}/lib)
      '';
    in
    ''
      rm -r src/h3lib
      substituteInPlace CMakeLists.txt \
        --replace-fail "add_subdirectory(src/h3lib)" "${cmakeCommands}" \
        --replace-fail "\''${CMAKE_CURRENT_BINARY_DIR}/src/h3lib/src/h3lib/include/h3api.h" "${lib.getDev h3}/include/h3/h3api.h"
    '';

  # Extra check to make sure we can import it from Python
  pythonImportsCheck = [ "h3" ];

  meta = {
    homepage = "https://github.com/uber/h3-py";
    description = "Hierarchical hexagonal geospatial indexing system";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.kalbasit ];
  };
}
