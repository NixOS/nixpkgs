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
  version = "2.12";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "filcole";
    repo = pname;
    # release not tagged: https://github.com/filcole/pycarwings2/issues/33
    rev = "0dc9e7e74cb119614c72c7f955801a366f303c56";
    sha256 = "sha256-3lyAgLuaNrCDvRT2yYkgaDiLPKW9Hbg05cQlMIBUs6o=";
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
