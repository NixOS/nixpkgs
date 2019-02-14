{ lib, buildPythonPackage, fetchPypi, future }:

buildPythonPackage rec {
  pname = "atom";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5b1c15599681398e343fcfcf2c00d26071964f5305a403fc590c45388bacdf16";
  };

  propagatedBuildInputs = [ future ];

  # Tests not released to pypi
  doCheck = true;

  meta = with lib; {
    description = "Memory efficient Python objects";
    maintainers = [ maintainers.bhipple ];
    homepage = https://github.com/nucleic/atom;
    license = licenses.bsd3;
  };
}
