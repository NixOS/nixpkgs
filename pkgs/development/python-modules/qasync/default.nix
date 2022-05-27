{ lib
, buildPythonPackage
, fetchFromGitHub
, pyside2
, pytest
}:

buildPythonPackage rec {
  version =  "0.23.0";
  src = fetchFromGitHub {
    owner = "CabbageDevelopment";
    repo = "qasync";
    rev = "58882735229b0d17836621d7d09ce02a6f80789d";
    sha256 = "sha256-2wustBtShydCXM5L5IQbOaZ2BfGxbIPwLZ8sRfxFnM4=";
  };

  pname = "qasync";

  propagatedBuildInputs = [ pyside2 ];

  # sigabrt
  # checkInputs = [pytest];
  # checkPhase = ''
  #   pytest
  # '';

  doCheck = false;

  meta = with lib; {
    description = "qasync allows coroutines to be used in PyQt/PySide applications by providing an implementation of the PEP 3156 event-loop.";
    homepage = "https://github.com/CabbageDevelopment/qasync";
    platforms = platforms.unix;
    maintainers = with maintainers; [rrix];
    license = with licenses; [ lgpl21 ];
  };
}
