{ lib
, buildPythonPackage
, fetchFromGitHub
, karton-core
, malduck
, pythonOlder
}:

buildPythonPackage rec {
  pname = "karton-config-extractor";
  version = "2.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ep69Rrm8Ek0lkgctz6vDAZ1MZ8kWKZSyIvMMAmzTngA=";
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
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
