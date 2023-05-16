{ lib
, buildPythonPackage
, certifi
, chardet
, fetchFromGitHub
, idna
, pythonOlder
, requests
, urllib3
}:

buildPythonPackage rec {
  pname = "frigidaire";
<<<<<<< HEAD
  version = "0.18.13";
=======
  version = "0.18.12";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bm1549";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-FikBV4KjutQfupGPXcVT1h+BfQ099WRrmbrEJOaVCQI=";
=======
    hash = "sha256-U6ko6P5/ANGy84GQDuSQq+YArou0TrXH5SIc5x4euvU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'version = "SNAPSHOT"' 'version = "${version}"'
  '';

  propagatedBuildInputs = [
    certifi
    chardet
    idna
    requests
    urllib3
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "frigidaire"
  ];

  meta = with lib; {
    description = "Python API for the Frigidaire devices";
    homepage = "https://github.com/bm1549/frigidaire";
    changelog = "https://github.com/bm1549/frigidaire/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
