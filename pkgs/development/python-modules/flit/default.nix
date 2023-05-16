{ lib
, buildPythonPackage
, fetchFromGitHub
, docutils
, requests
, pytestCheckHook
, testpath
, responses
, flit-core
, tomli-w
}:

# Flit is actually an application to build universal wheels.
# It requires Python 3 and should eventually be moved outside of
# python-packages.nix. When it will be used to build wheels,
# care should be taken that there is no mingling of PYTHONPATH.

buildPythonPackage rec {
  pname = "flit";
<<<<<<< HEAD
  version = "3.9.0";
=======
  version = "3.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "takluyver";
    repo = "flit";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-yl2+PcKr7xRW4oIBWl+gzh/nKhSNu5GH9fWKRGgaNHU=";
=======
    hash = "sha256-iXf9K/xI4u+dDV0Zf6S08nbws4NqycrTEW0B8/qCjQc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    docutils
    requests
    flit-core
    tomli-w
  ];

  nativeCheckInputs = [ pytestCheckHook testpath responses ];

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
<<<<<<< HEAD
    changelog = "https://github.com/pypa/flit/blob/${version}/doc/history.rst";
    description = "A simple packaging tool for simple packages";
    homepage = "https://github.com/pypa/flit";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
=======
    description = "A simple packaging tool for simple packages";
    homepage = "https://github.com/pypa/flit";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
