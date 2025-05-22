{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  docutils,
  pip,
  requests,
  tomli-w,

  # tests
  pytestCheckHook,
  testpath,
  responses,
}:

# Flit is actually an application to build universal wheels.
# It requires Python 3 and should eventually be moved outside of
# python-packages.nix. When it will be used to build wheels,
# care should be taken that there is no mingling of PYTHONPATH.

buildPythonPackage rec {
  pname = "flit";
  version = "3.12.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "flit";
    rev = version;
    hash = "sha256-oWV+KK22+iK99iCOCKCV1OCLq2Ef1bcYRKXT5GHwiL8=";
  };

  build-system = [ flit-core ];

  dependencies = [
    docutils
    flit-core
    pip
    requests
    tomli-w
  ];

  nativeCheckInputs = [
    pytestCheckHook
    testpath
    responses
  ];

  disabledTests = [
    # needs some ini file.
    "test_invalid_classifier"
    # calls pip directly. disabled for PEP 668
    "test_install_data_dir"
    "test_install_module_pep621"
    "test_symlink_data_dir"
    "test_symlink_module_pep621"
  ];

  meta = with lib; {
    changelog = "https://github.com/pypa/flit/blob/${version}/doc/history.rst";
    description = "Simple packaging tool for simple packages";
    mainProgram = "flit";
    homepage = "https://github.com/pypa/flit";
    license = licenses.bsd3;
  };
}
