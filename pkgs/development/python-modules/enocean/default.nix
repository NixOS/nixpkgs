{ lib
, buildPythonPackage
, fetchFromGitHub
, beautifulsoup4
, enum-compat
, pyserial
, nose
}:

buildPythonPackage rec {
  pname = "enocean";
  version = "0.60.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "kipe";
    repo = "enocean";
    rev = version;
    sha256 = "0cbcvvy3qaqv8925z608qmkc1l914crzw79krwrz2vpm2fyribab";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    enum-compat
    pyserial
  ];

  nativeCheckInputs = [
    nose
  ];

  checkPhase = ''
    runHook preCheck

    nosetests

    runHook postCheck
  '';

  pythonImportsCheck = [
    "enocean.communicators"
    "enocean.protocol.packet"
    "enocean.utils"
  ];

  meta = with lib; {
    description = "EnOcean serial protocol implementation";
    homepage = "https://github.com/kipe/enocean";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
