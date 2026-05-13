{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  robotframework,
  robotframework-assertion-engine,
  sqlparse,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "robotframework-databaselibrary";
  version = ".2.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MarketSquare";
    repo = "Robotframework-Database-Library";
    tag = "v${version}";
    hash = "sha256-qC3+E4i4r4eM4xEjowViWhyxx1uVbtwDU6/y9ZugnYI=";
  };

  build-system = [
    setuptools
  ];

  propagatedBuildInputs = [
    robotframework
    robotframework-assertion-engine
    sqlparse
  ];

  pythonImportsCheck = [ "DatabaseLibrary" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/MarketSquare/Robotframework-Database-Library/releases/tag/${src.tag}";
    description = "Database Library contains utilities meant for Robot Framework";
    homepage = "https://github.com/MarketSquare/Robotframework-Database-Library";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ talkara ];
  };
}
