{ lib
, buildPythonPackage
, fetchPypi
, wrapt
, pyserial
, nose
, mock
, pytest
, pytest-timeout }:

buildPythonPackage rec {
  pname = "python-can";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b5e93b2ee32bdd597d9d908afe5171c402a04c9678ba47b60f33506738b1375b";
  };

  propagatedBuildInputs = [ wrapt pyserial ];
  checkInputs = [ nose mock pytest pytest-timeout ];

  checkPhase = ''
    pytest -k "not test_writer_and_reader \
           and not test_reader \
           and not test_socketcan_on_ci_server"
  '';

  meta = with lib; {
    homepage = https://github.com/hardbyte/python-can;
    description = "CAN support for Python";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ sorki ];
  };
}
