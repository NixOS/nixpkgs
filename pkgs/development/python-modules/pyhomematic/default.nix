{ lib, buildPythonPackage, isPy3k, fetchPypi }:

buildPythonPackage rec {
  pname = "pyhomematic";
  version = "0.1.71";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0z09bw2mlhg7n9jyqmcyir306wpxr5nw1qsp5ps2iaw1qnyz5s9n";
  };

  # PyPI tarball does not include tests/ directory
  # Unreliable timing: https://github.com/danielperna84/pyhomematic/issues/126
  doCheck = false;

  meta = with lib; {
    description = "Python 3 Interface to interact with Homematic devices";
    homepage = "https://github.com/danielperna84/pyhomematic";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
