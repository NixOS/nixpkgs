{ lib
, autoit-ripper
, buildPythonPackage
, fetchFromGitHub
, karton-core
, malduck
, pythonOlder
, regex
}:

buildPythonPackage rec {
  pname = "karton-autoit-ripper";
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    sha256 = "1gclrrc0n72bfj4m55kk8d69zrfvnlwm9692ni9w7d2231mvv7bw";
  };

  propagatedBuildInputs = [
    autoit-ripper
    karton-core
    malduck
    regex
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "autoit-ripper==" "autoit-ripper>=" \
      --replace "malduck==" "malduck>=" \
      --replace "regex==" "regex>="
  '';

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "karton.autoit_ripper"
  ];

  meta = with lib; {
    description = "AutoIt script ripper for Karton framework";
    homepage = "https://github.com/CERT-Polska/karton-autoit-ripper";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
