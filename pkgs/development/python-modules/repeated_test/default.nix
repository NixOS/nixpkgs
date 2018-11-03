{ stdenv
, buildPythonPackage
, fetchPypi
, unittest2
, six
}:

buildPythonPackage rec {
  pname = "repeated_test";
  version = "0.1a3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "062syp7kl2g0x6qx3z8zb5sdycpi7qcpxp9iml2v8dqzqnij9bpg";
  };

  buildInputs = [ unittest2 ];
  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "A quick unittest-compatible framework for repeating a test function over many fixtures";
    homepage = "https://github.com/epsy/repeated_test";
    license = licenses.mit;
  };

}
