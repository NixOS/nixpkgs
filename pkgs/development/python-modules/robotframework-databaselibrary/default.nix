{ lib
, buildPythonPackage
, fetchPypi
, robotframework
}:

buildPythonPackage rec {
  version = "1.3.1";
  format = "setuptools";
  pname = "robotframework-databaselibrary";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-C+shwpGbiA+YS8t9ApJEv6mYQVd3fVvY3qWzDF6vYqU=";
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
