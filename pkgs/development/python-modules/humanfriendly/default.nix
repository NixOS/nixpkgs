{ lib
, pythonOlder
, buildPythonPackage
, fetchPypi
, monotonic
}:

buildPythonPackage rec {
  pname = "humanfriendly";
  version = "9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BmVilWY5qyH/JnbR/aC1mH6YXFNPx2cAoZvVS8uBEh0=";
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
