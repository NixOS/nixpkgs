{ lib
, buildPythonPackage
, fetchPypi
, nose
, can
, canmatrix }:

buildPythonPackage rec {
  pname = "canopen";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15d49f1f71e9989dde6e3b75fb8445c76bd223064dfc0ac629fe9ecb0e21fba9";
  };

  propagatedBuildInputs =
    [ can
      canmatrix
    ];

  checkInputs = [ nose ];

  meta = with lib; {
    homepage = "https://github.com/christiansandberg/canopen/";
    description = "CANopen stack implementation";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ sorki ];
  };
}
