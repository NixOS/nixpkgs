{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  robotframework,
  robotframework-assertion-engine,
  robotframework-excellib,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "robotframework-databaselibrary";
  version = "2.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MarketSquare";
    repo = "Robotframework-Database-Library";
    tag = "v.${version}";
    hash = "sha256-ixgKw5iZw81TlgvvbsJXI753OkHuyJHhSeNVqXtsY4w=";
  };

  nativeBuildInputs = [
    robotframework
    setuptools
  ];

  propagatedBuildInputs = [
    robotframework
    robotframework-assertion-engine
    robotframework-excellib
  ];

  pythonImportsCheck = [ "DatabaseLibrary" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Database Library contains utilities meant for Robot Framework";
    homepage = "https://github.com/MarketSquare/Robotframework-Database-Library";
    license = licenses.asl20;
    maintainers = with maintainers; [ talkara ];
  };
}
