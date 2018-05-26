{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pyserial
, nose
, mock }:

buildPythonPackage rec {
  pname = "python-can";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4a5c01dd67feeda35f88e6c12ea14ac8cabd426b9be0cc5f9fd083fe90a9dbfc";
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
