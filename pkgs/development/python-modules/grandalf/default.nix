{ lib
, buildPythonPackage
, fetchFromGitHub
, pyparsing
, future
, pytest
, pytestrunner
}:

buildPythonPackage rec {
  pname = "grandalf";
  version = "0.6";

  # fetch from github to acquire tests
  src = fetchFromGitHub {
    owner = "bdcht";
    repo = "grandalf";
    rev = "v${version}";
    sha256 = "1f1l288sqna0bca7dwwvyw7wzg9b2613g6vc0g0vfngm7k75b2jg";
  };

  propagatedBuildInputs = [
    pyparsing
    future
  ];

  checkInputs = [ pytest pytestrunner ];

  patches = [ ./no-setup-requires-pytestrunner.patch ];

  checkPhase = ''
    pytest tests
  '';

  meta = with lib; {
    description = "A python package made for experimentations with graphs and drawing algorithms";
    homepage = https://github.com/bdcht/grandalf;
    license = licenses.gpl2;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
