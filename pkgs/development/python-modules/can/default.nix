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
  version = "3.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ecd69cf6b2f0235345ebe607a15325cf1384c85b24ffbe1d68c3754357f87488";
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
