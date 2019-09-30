{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "kconfiglib";
  version = "12.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0afc0gidh0pjb0ll99xifzs5z14g365crfj935614zp9w8fcchp0";
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
