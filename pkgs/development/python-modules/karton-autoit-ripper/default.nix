{ lib
, autoit-ripper
, buildPythonPackage
, fetchFromGitHub
, karton-core
, malduck
, regex
}:

buildPythonPackage rec {
  pname = "karton-autoit-ripper";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vdsxkbjcr0inpcfjh45gl72ipzklkhgs06fdpkyy9y0cfx3zq7z";
  };

  propagatedBuildInputs = [
    autoit-ripper
    karton-core
    malduck
    regex
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "autoit-ripper==1.0.0" "autoit-ripper" \
      --replace "karton.core==4.0.4" "karton-core" \
      --replace "malduck==3.1.0" "malduck>=3.1.0" \
      --replace "regex==2020.2.20" "regex>=2020.2.20"
  '';

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "karton.autoit_ripper" ];

  meta = with lib; {
    description = "AutoIt script ripper for Karton framework";
    homepage = "https://github.com/CERT-Polska/karton-autoit-ripper";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
