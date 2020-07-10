{ stdenv, buildPythonPackage, isPy3k, fetchPypi }:

buildPythonPackage rec {
  pname = "pyhomematic";
  version = "0.1.67";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2d18e0059367e9e32d6472023322113fce431bcc72187b4a6eb7402fe5d2794b";
  };

  # PyPI tarball does not include tests/ directory
  # Unreliable timing: https://github.com/danielperna84/pyhomematic/issues/126
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python 3 Interface to interact with Homematic devices";
    homepage = "https://github.com/danielperna84/pyhomematic";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
