{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "humanfriendly";
  version = "10.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc";
  };

  # humanfriendly tests depends on coloredlogs which itself depends on
  # humanfriendly. This lead to infinite recursion when trying to
  # build this package so we have to disable the test suite :(
  doCheck = false;

  meta = with lib; {
    description = "Human friendly output for text interfaces using Python";
    mainProgram = "humanfriendly";
    homepage = "https://humanfriendly.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ montag451 ];
  };
}
