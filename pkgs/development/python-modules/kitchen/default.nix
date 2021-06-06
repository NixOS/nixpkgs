{ lib, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "kitchen";
  version = "1.2.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0g5hq2icnng9vy4www5hnr3r5srisfwp0wxw1sv5c5dxy61gak5q";
  };

  meta = with lib; {
    description = "Kitchen contains a cornucopia of useful code";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ ];
  };
}
