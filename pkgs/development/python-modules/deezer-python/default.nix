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
  version = "2.2.4";
  disabled = pythonOlder "3.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "browniebroke";
    repo = pname;
    rev = "v${version}";
    sha256 = "11gqmyf350256gbppak2qv20lg2bmszand4kmks93wphq5yp2iiy";
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
