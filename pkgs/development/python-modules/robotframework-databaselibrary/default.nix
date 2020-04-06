{ stdenv
, buildPythonPackage
, fetchPypi
, robotframework
}:

buildPythonPackage rec {
  version = "1.2.4";
  pname = "robotframework-databaselibrary";

  src = fetchPypi {
    inherit pname version;
    sha256 = "627d872b3dda6a308a650ac9e676dadedf9c294e4ef70ad207cbb86b78eb8847";
  };

  # unit tests are impure
  doCheck = false;

  propagatedBuildInputs = [ robotframework ];

  meta = with stdenv.lib; {
    description = "Database Library contains utilities meant for Robot Framework";
    homepage = https://github.com/franz-see/Robotframework-Database-Library;
    license = licenses.asl20;
    maintainers = with maintainers; [ talkara ];
  };

}
