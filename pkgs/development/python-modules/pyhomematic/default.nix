{ stdenv, buildPythonPackage, isPy3k, fetchPypi }:

buildPythonPackage rec {
  pname = "pyhomematic";
  version = "0.1.68";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7f8ec68238a441cfe593fa9028509fd0c3dc67400b4dd520c8c02088f177302e";
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
