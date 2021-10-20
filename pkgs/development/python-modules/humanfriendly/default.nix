{ lib
, pythonOlder
, buildPythonPackage
, fetchPypi
, monotonic
}:

buildPythonPackage rec {
  pname = "humanfriendly";
  version = "9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f7dba53ac7935fd0b4a2fc9a29e316ddd9ea135fb3052d3d0279d10c18ff9c48";
  };

  propagatedBuildInputs = lib.optional (pythonOlder "3.3") monotonic;

  # humanfriendly tests depends on coloredlogs which itself depends on
  # humanfriendly. This lead to infinite recursion when trying to
  # build this package so we have to disable the test suite :(
  doCheck = false;

  meta = with lib; {
    description = "Human friendly output for text interfaces using Python";
    homepage = "https://humanfriendly.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ montag451 ];
  };
}
