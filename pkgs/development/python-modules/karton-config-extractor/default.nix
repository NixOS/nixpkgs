{ lib
, buildPythonPackage
, fetchFromGitHub
, karton-core
, malduck
, pythonOlder
}:

buildPythonPackage rec {
  pname = "karton-config-extractor";
  version = "2.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-X2g/wgWLIY2ZIwH1l83EApyoeYQU5/MWq5S0qmYz+CA=";
  };

  propagatedBuildInputs = [
    karton-core
    malduck
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "malduck==4.1.0" "malduck"
  '';

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "karton.config_extractor"
  ];

  meta = with lib; {
    description = "Static configuration extractor for the Karton framework";
    homepage = "https://github.com/CERT-Polska/karton-config-extractor";
    changelog = "https://github.com/CERT-Polska/karton-config-extractor/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
