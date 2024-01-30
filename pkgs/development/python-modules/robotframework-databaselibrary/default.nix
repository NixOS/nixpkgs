{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, robotframework
, robotframework-excellib
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "robotframework-databaselibrary";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MarketSquare";
    repo = "Robotframework-Database-Library";
    rev = "refs/tags/v${version}";
    hash = "sha256-BCVXmlrYOaG+Dh67OytUfQnJ9Ak3MtHR3swOXdAN/HU=";
  };

  nativeBuildInputs = [
    robotframework
    setuptools
  ];

  propagatedBuildInputs = [
    robotframework
    robotframework-excellib
  ];

  pythonImportsCheck = [ "DatabaseLibrary" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Database Library contains utilities meant for Robot Framework";
    homepage = "https://github.com/MarketSquare/Robotframework-Database-Library";
    license = licenses.asl20;
    maintainers = with maintainers; [ talkara ];
  };

}
