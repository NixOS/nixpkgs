{ stdenv, buildPythonPackage, fetchPypi, isPy33, pythonOlder }:

buildPythonPackage rec {
  pname = "asyncio";
  version = "3.4.3";
  disabled = pythonOlder "3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hfbqwk9y0bbfgxzg93s2wyk6gcjsdxlr5jwy97hx64ppkw0ydl3";
  };

  meta = with stdenv.lib; {
    description = "Reference implementation of PEP 3156";
    homepage = http://www.python.org/dev/peps/pep-3156;
    license = licenses.free;
  };
}
