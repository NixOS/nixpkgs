{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pur";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "alanhamlett";
    repo = "pip-update-requirements";
    rev = version;
    sha256 = "1p2g0kz9l0rb59b3rkclb6wwidc93kwqh2hm4xc22b1w9r946six";
  };

  propagatedBuildInputs = [
    click
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pur" ];

  meta = with lib; {
    description = "Python library for update and track the requirements";
    homepage = "https://github.com/alanhamlett/pip-update-requirements";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
