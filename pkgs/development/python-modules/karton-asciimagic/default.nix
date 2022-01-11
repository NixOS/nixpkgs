{ lib
, buildPythonPackage
, fetchFromGitHub
, karton-core
, python
}:

buildPythonPackage rec {
  pname = "karton-asciimagic";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vj4b8man81g99g4c53zyvp1gc47c2imj5ha9r4z4bf8gs3aqsv6";
  };

  propagatedBuildInputs = [
    karton-core
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m unittest discover
    runHook postCheck
  '';

  pythonImportsCheck = [ "karton.asciimagic" ];

  meta = with lib; {
    description = "Decoders for ascii-encoded executables for the Karton framework";
    homepage = "https://github.com/CERT-Polska/karton-asciimagic";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
