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
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d2ddb3b663af51b11a4c7fb7a577c63302a831986239f82bb6af65efc065b07";
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
