{ lib
, buildPythonPackage
, fetchFromGitHub
, flexmock
, pytest
, pytest-cov
, six
}:

buildPythonPackage rec {
  pname = "iocapture";
  version = "0.1.2";

  src = fetchFromGitHub {
     owner = "oinume";
     repo = "iocapture";
     rev = "0.1.2";
     sha256 = "0q1r14lfxl1rf7wq6ha8ns2c6lcrnpmypf28xrharmznm28d5igp";
  };

  checkInputs = [
    flexmock
    pytest
    pytest-cov
    six
  ];

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "Capture stdout, stderr easily.";
    homepage = "https://github.com/oinume/iocapture";
    license = licenses.mit;
  };
}
