{ stdenv, buildPythonPackage, fetchPypi
, isPy33, isPy26, isPy27, isPyPy, python, pycares, asyncio, trollius }:

buildPythonPackage rec {
  pname = "aiodns";
  version = "1.1.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d8677adc679ce8d0ef706c14d9c3d2f27a0e0cc11d59730cdbaf218ad52dd9ea";
  };

  propagatedBuildInputs = with stdenv.lib; [ pycares ] 
    ++ optional isPy33 asyncio 
    ++ optional (isPy26 || isPy27 || isPyPy) trollius;

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
