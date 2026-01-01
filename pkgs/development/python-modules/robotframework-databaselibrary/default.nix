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
  version = "2.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MarketSquare";
    repo = "Robotframework-Database-Library";
    tag = "v.${version}";
    hash = "sha256-ZZOhGZTJGWYCHyvJXDYGn9BMuPioCVIu0KONGkXsRmk=";
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

<<<<<<< HEAD
  meta = {
    description = "Database Library contains utilities meant for Robot Framework";
    homepage = "https://github.com/MarketSquare/Robotframework-Database-Library";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ talkara ];
=======
  meta = with lib; {
    description = "Database Library contains utilities meant for Robot Framework";
    homepage = "https://github.com/MarketSquare/Robotframework-Database-Library";
    license = licenses.asl20;
    maintainers = with maintainers; [ talkara ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
