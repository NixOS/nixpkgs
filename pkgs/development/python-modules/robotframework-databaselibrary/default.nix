{ lib
, buildPythonPackage
, fetchPypi
, robotframework
}:

buildPythonPackage rec {
  version = "1.4.1";
  pname = "robotframework-databaselibrary";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/n4+xA/eLrcVEwlWyLQLrkX5waYaJKRkphwT22b7hTU=";
  };

  # unit tests are impure
  doCheck = false;

  propagatedBuildInputs = [ robotframework ];

  meta = with lib; {
    description = "Database Library contains utilities meant for Robot Framework";
    homepage = "https://github.com/franz-see/Robotframework-Database-Library";
    license = licenses.asl20;
    maintainers = with maintainers; [ talkara ];
  };

}
