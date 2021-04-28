{ lib
, buildPythonPackage
, fetchFromGitHub
, karton-core
, python
}:

buildPythonPackage rec {
  pname = "karton-asciimagic";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    sha256 = "0yvd0plpwy5qkd2jljpd6wm6dlj2g8csvj1q2md23vsgx7h7v2vm";
  };

  propagatedBuildInputs = [
    karton-core
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "karton.core==4.0.5" "karton-core"
  '';

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
