{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, six
, pytest-datadir
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "jproperties";
  version = "2.1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Tblue";
    repo = "python-jproperties";
    rev = "v${version}";
    hash = "sha256-O+ALeGHMNjW1dc9IRyLzO81k8DW2vbGjuZqXxgrhYjo=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [
    pytest-datadir
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "setuptools_scm ~= 3.3" "setuptools_scm"
    substituteInPlace pytest.ini \
      --replace "--cov=jproperties --cov-report=term --cov-report=html --cov-branch" ""
  '';

  disabledTestPaths = [
    # TypeError: 'PosixPath' object...
    "tests/test_simple_utf8.py"
  ];

  pythonImportsCheck = [
    "jproperties"
  ];

  meta = with lib; {
    description = "Java Property file parser and writer for Python";
    homepage = "https://github.com/Tblue/python-jproperties";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
