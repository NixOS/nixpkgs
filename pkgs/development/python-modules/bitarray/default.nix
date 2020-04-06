{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "1.2.1";
  pname = "bitarray";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kxrlxfj9nrx512sfwifwl9z4v6ky3qschl0zmk3s3dvc3s7bmif";
  };

  meta = with lib; {
    description = "Efficient arrays of booleans";
    homepage = https://github.com/ilanschnell/bitarray;
    license = licenses.psfl;
    maintainers = [ maintainers.bhipple ];
  };
}
