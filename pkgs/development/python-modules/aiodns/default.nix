{ stdenv, buildPythonPackage, fetchPypi
, isPy33, isPy26, isPy27, isPyPy, python, pycares, asyncio, trollius }:

buildPythonPackage rec {
  pname = "aiodns";
  version = "1.0.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "595b78b8d54115d937cf60d778c02dad76b6f789fd527dab308f99e5601e7f3d";
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
    homepage = http://github.com/saghul/aiodns;
    license = licenses.mit;
    description = "Simple DNS resolver for asyncio";
  };
}
