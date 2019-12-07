{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "kconfiglib";
  version = "13.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "045yjmn6xqbyb68l1jqlgi3c8cwlw1krsrlfwrrgjijkmbx6yqmd";
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
