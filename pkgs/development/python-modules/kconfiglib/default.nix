{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "kconfiglib";
  version = "10.36.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qhy4vv1rpgx4r1la14symxv3cpz7klqakn1rqdagwyaqp667g9b";
  };

  # doesnt work out of the box but might be possible
  doCheck = false;

  meta = with lib; {
    description = "A flexible Python 2/3 Kconfig implementation and library";
    homepage = https://github.com/ulfalizer/Kconfiglib;
    license = licenses.isc;
    maintainers = with maintainers; [ teto ];
  };
}
