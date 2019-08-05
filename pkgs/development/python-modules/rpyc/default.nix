{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, plumbum
}:

buildPythonPackage rec {
  pname = "rpyc";
  version = "4.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rhmwq1jra2cs0j09z2ks4vnv0svi8lj21nq9qq50i52x4ml4yb7";
  };

  propagatedBuildInputs = [ nose plumbum ];

  meta = with stdenv.lib; {
    description = "Remote Python Call (RPyC), a transparent and symmetric RPC library";
    homepage = https://rpyc.readthedocs.org;
    license = licenses.mit;
  };

}
