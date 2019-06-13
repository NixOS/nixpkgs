{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, plumbum
}:

buildPythonPackage rec {
  pname = "rpyc";
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pz90h21f74n8i3cx5ndxm4r3rismkx5qbw1c0cmfci9a3009rq5";
  };

  propagatedBuildInputs = [ nose plumbum ];

  meta = with stdenv.lib; {
    description = "Remote Python Call (RPyC), a transparent and symmetric RPC library";
    homepage = https://rpyc.readthedocs.org;
    license = licenses.mit;
  };

}
