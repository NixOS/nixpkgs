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
  version = "1.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MarketSquare";
    repo = "Robotframework-Database-Library";
    rev = "refs/tags/v${version}";
    hash = "sha256-b909Sm8frygZO2hFhfmcVILx5U3Nnyui5ttc6f3bGW0=";
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
