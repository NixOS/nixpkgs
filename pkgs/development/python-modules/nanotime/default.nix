{ lib, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "nanotime";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c7cc231fc5f6db401b448d7ab51c96d0a4733f4b69fabe569a576f89ffdf966b";
  };

  nativeCheckInputs = [ nose ];

  checkPhase = ''
    nosetests
  '';

  # tests currently fail
  doCheck = false;

  meta = with lib; {
    description = "Provides a time object that keeps time as the number of nanoseconds since the UNIX epoch";
    homepage = "https://github.com/jbenet/nanotime/tree/master/python";
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
