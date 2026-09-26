{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  nanobind,
  ninja,
  pcpp,
  scikit-build-core,
  typing-extensions,

  # buildInputs
  isl,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "islpy";
  version = "2026.2.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "inducer";
    repo = "islpy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rsmEMZty80qG1RXf2V5MXwchv0sQZ3jV9Go7FXzKzNY=";
  };

  build-system = [
    cmake
    nanobind
    ninja
    pcpp
    scikit-build-core
    typing-extensions
  ];

  buildInputs = [
    isl
  ];

  dontUseCmakeConfigure = true;

  cmakeFlags = [
    (lib.cmakeBool "USE_SHIPPED_ISL" false)
    (lib.cmakeBool "USE_BARVINOK" false)
    (lib.cmakeOptionType "list" "ISL_INC_DIRS" "${lib.getDev isl}/include")
    (lib.cmakeOptionType "list" "ISL_LIB_DIRS" "${lib.getLib isl}/lib")
  ];

  # Force resolving the package from $out to make generated ext files usable by tests
  preCheck = ''
    rm -rf islpy
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "islpy" ];

  meta = {
    description = "Python wrapper around isl, an integer set library";
    homepage = "https://github.com/inducer/islpy";
    changelog = "https://github.com/inducer/islpy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
})
