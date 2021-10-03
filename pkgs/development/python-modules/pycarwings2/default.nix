{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, pyyaml
, iso8601
, requests
, pycryptodome
}:

buildPythonPackage rec {
  pname = "pycarwings2";
  version = "2.11";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "filcole";
    repo = pname;
    rev = "v${version}";
    sha256 = "0daqxnic7kphspqqq8a0bjp009l5a7d1k72q6cz43g7ca6wfq4b1";
  };

  propagatedBuildInputs = [
    pyyaml
    iso8601
    requests
    pycryptodome
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'" ""
    substituteInPlace setup.cfg \
      --replace " --flake8 --cov=pycarwings2 --cache-clear --ignore=venv --verbose" ""
  '';

  disabledTests = [
    # Test requires network access
    "test_bad_password"
  ];

  pythonImportsCheck = [
    "pycarwings2"
  ];

  meta = with lib; {
    description = "Python library for interacting with the NissanConnect EV";
    homepage = "https://github.com/filcole/pycarwings2";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
