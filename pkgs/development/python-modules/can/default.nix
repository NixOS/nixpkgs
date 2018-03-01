{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pyserial
, nose
, mock }:

buildPythonPackage rec {
  pname = "python-can";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c6zfd29ck9ffdklfb5xgxvfl52xdaqd89isykkypm1ll97yk2fs";
  };

  propagatedBuildInputs = [ pyserial ];
  checkInputs = [ nose mock ];

  meta = with lib; {
    homepage = https://github.com/hardbyte/python-can;
    description = "CAN support for Python";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ sorki ];
  };
}
