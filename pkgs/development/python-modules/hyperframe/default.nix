{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "hyperframe";
  version = "5.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a9f5c17f2cc3c719b917c4f33ed1c61bd1f8dfac4b1bd23b7c80b3400971b41f";
  };

  meta = with stdenv.lib; {
    description = "HTTP/2 framing layer for Python";
    homepage = "http://hyper.rtfd.org/";
    license = licenses.mit;
  };
}
