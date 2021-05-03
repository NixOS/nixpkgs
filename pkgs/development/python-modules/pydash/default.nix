{ lib, buildPythonPackage, fetchFromGitHub, mock, pytestCheckHook, invoke }:

buildPythonPackage rec {
  pname = "pydash";
  version = "4.9.3";

  src = fetchFromGitHub {
    owner = "dgilland";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BAyiSnILvujUOFOAkiXSgyozs2Q809pYihHwa+6BHcQ=";
  };

  patches = [ ./0001-Only-build-unit-tests.patch ];

  checkInputs = [ mock pytestCheckHook invoke ];

  meta = with lib; {
    homepage = "https://github.com/dgilland/pydash";
    description = "The kitchen sink of Python utility libraries for doing \"stuff\" in a functional way. Based on the Lo-Dash Javascript library.";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
  };
}
