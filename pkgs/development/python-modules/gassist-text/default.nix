{ lib
, beautifulsoup4
, buildPythonPackage
, fetchFromGitHub
, google-auth
, grpcio
, protobuf
, pytestCheckHook
, pythonOlder
, requests
, setuptools
}:

buildPythonPackage rec {
  pname = "gassist-text";
  version = "0.0.10";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tronikos";
    repo = "gassist_text";
    rev = "refs/tags/${version}";
    hash = "sha256-BSMflCSYNAaQVTOqKWyr9U9Q70ley1jjF6ndOVum+GA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    google-auth
    grpcio
    protobuf
    requests
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "gassist_text"
  ];

  meta = with lib; {
    description = "Module for interacting with Google Assistant API via text";
    homepage = "https://github.com/tronikos/gassist_text";
    changelog = "https://github.com/tronikos/gassist_text/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
