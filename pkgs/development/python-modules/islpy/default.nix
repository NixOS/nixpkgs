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
  imath,
  isl,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "islpy";
  version = "2025.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inducer";
    repo = "islpy";
    tag = "v${version}";
    hash = "sha256-6VNA07XnzmOTsrH16fXzEdl1HmShmrtUjQyUs18CxYc=";
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
    imath
    isl
  ];

  dontUseCmakeConfigure = true;

  pypaBuildFlags = [
    "--config-setting=cmake.define.USE_SHIPPED_ISL=OFF"
    "--config-setting=cmake.define.USE_SHIPPED_IMATH=OFF"
    "--config-setting=cmake.define.USE_BARVINOK=OFF"
    "--config-setting=cmake.define.ISL_INC_DIRS:LIST='${lib.getDev isl}/include'"
    "--config-setting=cmake.define.ISL_LIB_DIRS:LIST='${lib.getLib isl}/lib'"
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
    changelog = "https://github.com/inducer/islpy/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
