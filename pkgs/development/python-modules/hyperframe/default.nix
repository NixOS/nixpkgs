{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "hyperframe";
  version = "5.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07xlf44l1cw0ghxx46sbmkgzil8vqv8kxwy42ywikiy35izw3xd9";
  };

  meta = with stdenv.lib; {
    description = "HTTP/2 framing layer for Python";
    homepage = "http://hyper.rtfd.org/";
    license = licenses.mit;
  };
}
