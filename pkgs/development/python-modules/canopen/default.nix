{ lib
, buildPythonPackage
, fetchPypi
, nose
, can
, canmatrix }:

buildPythonPackage rec {
  pname = "canopen";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fqa4p3qg7800fykib1x264gizhhmb6dz2hajgwr0hxf5xa19wdl";
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
