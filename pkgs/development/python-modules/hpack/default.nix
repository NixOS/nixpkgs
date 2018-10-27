{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "hpack";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ad0fx4d7a52zf441qzhjc7vwy9v3qdrk1zyf06ikz8y2nl9mgai";
  };

  meta = with stdenv.lib; {
    description = "Pure-Python HPACK header compression";
    homepage = "http://hyper.rtfd.org";
    license = licenses.mit;
  };

}
