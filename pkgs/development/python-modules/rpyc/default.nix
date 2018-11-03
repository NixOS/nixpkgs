{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, plumbum
}:

buildPythonPackage rec {
  pname = "rpyc";
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "43fa845314f0bf442f5f5fab15bb1d1b5fe2011a8fc603f92d8022575cef8b4b";
  };

  propagatedBuildInputs = [ nose plumbum ];

  meta = with stdenv.lib; {
    description = "Remote Python Call (RPyC), a transparent and symmetric RPC library";
    homepage = http://rpyc.readthedocs.org;
    license = licenses.mit;
  };

}
