{ lib
, buildPythonPackage
, fetchFromGitHub
, karton-core
, malduck
, pythonOlder
}:

buildPythonPackage rec {
  pname = "karton-config-extractor";
<<<<<<< HEAD
  version = "2.2.0";
=======
  version = "2.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-X2g/wgWLIY2ZIwH1l83EApyoeYQU5/MWq5S0qmYz+CA=";
=======
    hash = "sha256-ep69Rrm8Ek0lkgctz6vDAZ1MZ8kWKZSyIvMMAmzTngA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
