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
  version = "2.2.2";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "browniebroke";
    repo = pname;
    rev = "v${version}";
    sha256 = "1l8l4lxlqsj921gk1mxcilp11jx31addiyd9pk604aldgqma709y";
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
