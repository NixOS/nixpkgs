{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  robotframework,
  robotframework-assertion-engine,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "robotframework-databaselibrary";
  version = "2.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MarketSquare";
    repo = "Robotframework-Database-Library";
    tag = "v${version}";
    hash = "sha256-RGTx5Xn40MHr5M6DUb3dkR2OU7B0JKuFYP1o18o3Ct4=";
  };

  nativeBuildInputs = [
    robotframework
    setuptools
  ];

  propagatedBuildInputs = [
    robotframework
    robotframework-assertion-engine
  ];

  pythonImportsCheck = [ "DatabaseLibrary" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Database Library contains utilities meant for Robot Framework";
    homepage = "https://github.com/MarketSquare/Robotframework-Database-Library";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ talkara ];
  };
}
