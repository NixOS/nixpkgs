{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pymongo,
}:

buildPythonPackage rec {
  pname = "pymongo-search-utils";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mongodb-labs";
    repo = "pymongo-search-utils";
    tag = version;
    hash = "sha256-R0GYfVeLc0zfzfEGBil/AHyt20Y0bEo+eQ9wtdNwJL8=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    pymongo
  ];

  # tests require mongodb running in the background
  doCheck = false;

  pythonImportsCheck = [
    "pymongo_search_utils"
  ];

  meta = {
    description = "Vector Search utilities for PyMongo";
    homepage = "https://github.com/mongodb-labs/pymongo-search-utils/";
    changelog = "https://github.com/mongodb-labs/pymongo-search-utils/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
