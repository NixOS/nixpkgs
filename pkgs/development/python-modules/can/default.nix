{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pyserial
, nose
, mock }:

buildPythonPackage rec {
  pname = "python-can";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b5e93b2ee32bdd597d9d908afe5171c402a04c9678ba47b60f33506738b1375b";
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
