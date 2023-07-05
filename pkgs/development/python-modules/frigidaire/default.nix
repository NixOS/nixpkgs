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
  version = "0.18.13";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bm1549";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-FikBV4KjutQfupGPXcVT1h+BfQ099WRrmbrEJOaVCQI=";
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
