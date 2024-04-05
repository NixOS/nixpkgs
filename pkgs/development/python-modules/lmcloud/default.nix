{ lib
, authlib
, bleak
, buildPythonPackage
, fetchFromGitHub
, httpx
, pythonOlder
, setuptools
, websockets
}:

buildPythonPackage rec {
  pname = "lmcloud";
  version = "0.4.35";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "zweckj";
    repo = "lmcloud";
    rev = "refs/tags/v${version}";
    hash = "sha256-TUve21yamtEmEceK/V1w7IZjnMgKConMfSY/GlqFpp8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    authlib
    bleak
    httpx
    websockets
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "lmcloud"
  ];

  meta = with lib; {
    description = "Library to interface with La Marzocco's cloud";
    homepage = "https://github.com/zweckj/lmcloud";
    changelog = "https://github.com/zweckj/lmcloud/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
