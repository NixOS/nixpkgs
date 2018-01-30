{ stdenv, buildPythonPackage, isPy3k, fetchPypi }:

buildPythonPackage rec {
  pname = "pyhomematic";
  version = "0.1.38";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "15b09ppn5sn3vpnwfb7gygrvn5v65k3zvahkfx2kqpk1xah0mqbf";
  };

  # Tests reuire network access
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python 3 Interface to interact with Homematic devices";
    homepage = https://github.com/danielperna84/pyhomematic;
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
