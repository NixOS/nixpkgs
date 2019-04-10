{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, plumbum
}:

buildPythonPackage rec {
  pname = "rpyc";
  version = "4.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a0d87cbad152f25e3702a03cb7fd67f6b10c87680a60ec3aea8dca5a56307c10";
  };

  propagatedBuildInputs = [ nose plumbum ];

  meta = with stdenv.lib; {
    description = "Remote Python Call (RPyC), a transparent and symmetric RPC library";
    homepage = http://rpyc.readthedocs.org;
    license = licenses.mit;
  };

}
