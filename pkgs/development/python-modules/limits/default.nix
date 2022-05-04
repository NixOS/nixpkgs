{ lib, fetchPypi, buildPythonPackage, six }:

buildPythonPackage rec {
  pname = "limits";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jiK2PfJjECB6d7db1HRZnwpGE6fZFjZQ7TpCjpzHrjU=";
  };

  propagatedBuildInputs = [ six ];

  doCheck = false; # ifilter

  meta = with lib; {
    description = "Rate limiting utilities";
    license = licenses.mit;
    homepage = "https://limits.readthedocs.org/";
  };
}
