{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  six,
  pytest-cov-stub,
  pytest-datadir,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "jproperties";
  version = "2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Tblue";
    repo = "python-jproperties";
    tag = "v${version}";
    hash = "sha256-wnhEcPWAFUXR741/LZT3TXqxrU70JZe+90AkVEA3A+k=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "setuptools_scm ~= 3.3" "setuptools_scm"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ six ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-datadir
    pytestCheckHook
  ];

  disabledTestPaths = [
    # TypeError: 'PosixPath' object...
    "tests/test_simple_utf8.py"
  ];

  pythonImportsCheck = [ "jproperties" ];

  meta = with lib; {
    description = "Java Property file parser and writer for Python";
    homepage = "https://github.com/Tblue/python-jproperties";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
    mainProgram = "propconv";
  };
}
