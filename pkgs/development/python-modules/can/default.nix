{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, isPy27
, aenum
, wrapt
, typing ? null
, pyserial
, nose
, mock
, hypothesis
, future
, pytest
, pytest-timeout }:

buildPythonPackage rec {
  pname = "python-can";
  version = "3.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2d3c223b7adc4dd46ce258d4a33b7e0dbb6c339e002faa40ee4a69d5fdce9449";
  };

  propagatedBuildInputs = [ wrapt pyserial aenum ] ++ lib.optional (pythonOlder "3.5") typing;
  checkInputs = [ nose mock pytest hypothesis future ];

  # Add the scripts to PATH
  checkPhase = ''
    PATH=$out/bin:$PATH pytest -c /dev/null
  '';

  meta = with lib; {
    homepage = "https://github.com/hardbyte/python-can";
    description = "CAN support for Python";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ sorki ];
  };
}
