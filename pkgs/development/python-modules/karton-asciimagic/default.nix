{ lib
, buildPythonPackage
, fetchFromGitHub
, karton-core
, python
}:

buildPythonPackage rec {
  pname = "karton-asciimagic";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    sha256 = "0d15fhb3y0jpwdfm4y11i6pmfa9szr943cm6slvf0ir31f9nznyz";
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
