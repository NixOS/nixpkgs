{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, isPy27
, aenum
, wrapt
, typing
, pyserial
, nose
, mock
, hypothesis
, future
, pytest
, pytest-timeout }:

buildPythonPackage rec {
  pname = "python-can";
  version = "3.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5fefb5c1e7e7f07faefc02c6eac79f9b58376f007048a04d8e7f325d48ec6b2e";
  };

  propagatedBuildInputs = [ wrapt pyserial aenum ] ++ lib.optional (pythonOlder "3.5") typing;
  checkInputs = [ nose mock pytest hypothesis future ];

  # Add the scripts to PATH
  checkPhase = ''
    PATH=$out/bin:$PATH pytest -c /dev/null
  '';

  meta = with lib; {
    homepage = https://github.com/hardbyte/python-can;
    description = "CAN support for Python";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ sorki ];
  };
}
