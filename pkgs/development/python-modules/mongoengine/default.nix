{ lib
, blinker
, buildPythonPackage
, fetchFromGitHub
, pillow
, pymongo
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mongoengine";
  version = "0.27.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MongoEngine";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-UCd7RpsSNDKh3vgVRYrFYWYVLQuK7WI0n/Moukhq5dM=";
  };

  propagatedBuildInputs = [
    pymongo
  ];

  nativeCheckInputs = [
    blinker
    pillow
    pytestCheckHook
  ];

  # Tests require mongodb running in background
  doCheck = false;

  pythonImportsCheck = [
    "mongoengine"
  ];

  meta = with lib; {
    description = "Object-Document Mapper for working with MongoDB";
    homepage = "http://mongoengine.org/";
    changelog = "https://github.com/MongoEngine/mongoengine/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
