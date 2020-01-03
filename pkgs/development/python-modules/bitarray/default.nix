{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "1.1.0";
  pname = "bitarray";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nv1283qcfilhnb4q6znlijply6lfxwpvp10cr0v33l0qwa86mwz";
  };

  meta = with lib; {
    description = "Efficient arrays of booleans";
    homepage = https://github.com/ilanschnell/bitarray;
    license = licenses.psfl;
    maintainers = [ maintainers.bhipple ];
  };
}
