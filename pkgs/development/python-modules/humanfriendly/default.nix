{ lib
, pythonOlder
, buildPythonPackage
, fetchPypi
, monotonic
}:

buildPythonPackage rec {
  pname = "humanfriendly";
  version = "8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf52ec91244819c780341a3438d5d7b09f431d3f113a475147ac9b7b167a3d12";
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
