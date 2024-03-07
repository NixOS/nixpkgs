{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, robotframework
}:

buildPythonPackage rec {
  pname = "robotframework-databaselibrary";
  version = "1.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/n4+xA/eLrcVEwlWyLQLrkX5waYaJKRkphwT22b7hTU=";
  };

  nativeBuildInputs = [
    robotframework
    setuptools
  ];

  propagatedBuildInputs = [
    robotframework
  ];

  # unit tests are impure
  doCheck = false;

  meta = with lib; {
    description = "Database Library contains utilities meant for Robot Framework";
    homepage = "https://github.com/franz-see/Robotframework-Database-Library";
    license = licenses.asl20;
    maintainers = with maintainers; [ talkara ];
  };

}
