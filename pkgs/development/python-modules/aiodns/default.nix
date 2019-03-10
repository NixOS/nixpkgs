{ stdenv, buildPythonPackage, fetchPypi
, isPy33, isPy27, isPyPy, python, pycares, typing, asyncio, trollius }:

buildPythonPackage rec {
  pname = "aiodns";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d67e14b32176bcf3ff79b5d47c466011ce4adeadfa264f7949da1377332a0449";
  };

  propagatedBuildInputs = with stdenv.lib; [ pycares typing ]
    ++ optional (isPy27 || isPyPy) trollius;

  checkPhase = ''
    ${python.interpreter} tests.py
  '';

  # 'Could not contact DNS servers'
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/saghul/aiodns;
    license = licenses.mit;
    description = "Simple DNS resolver for asyncio";
  };
}
