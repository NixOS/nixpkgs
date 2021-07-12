{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, requests
, tornado
, poetry-core
, pytestCheckHook
, pytest-cov
, pytest-vcr
}:

buildPythonPackage rec {
  pname = "deezer-python";
  version = "2.3.0";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "browniebroke";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pRYC0kJHJ5SKgDdGS1KkQEbv+DkF9oPw/A1GnB0AwfQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  checkInputs = [
    pytestCheckHook
    pytest-cov
    pytest-vcr
  ];

  propagatedBuildInputs = [
    requests
    tornado
  ];

  meta = with lib; {
    description = "A friendly Python wrapper around the Deezer API";
    homepage = "https://github.com/browniebroke/deezer-python";
    license = licenses.mit;
    maintainers = with maintainers; [ synthetica ];
  };
}
