{ stdenv
, buildPythonPackage
, fetchPypi
, unittest2
, six
}:

buildPythonPackage rec {
  pname = "repeated_test";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "65107444a4945668ab7be6d1a3e1814cee9b2cfc577e7c70381700b11b809d27";
  };

  buildInputs = [ unittest2 ];
  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "A quick unittest-compatible framework for repeating a test function over many fixtures";
    homepage = "https://github.com/epsy/repeated_test";
    license = licenses.mit;
  };

}
