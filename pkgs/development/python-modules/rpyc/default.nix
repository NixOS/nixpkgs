{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, plumbum
}:

buildPythonPackage rec {
  pname = "rpyc";
  version = "4.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0df276076891797bbaaff322cc6debb02e10817426bba00a9beca915053a8a91";
  };

  propagatedBuildInputs = [ nose plumbum ];

  meta = with stdenv.lib; {
    description = "Remote Python Call (RPyC), a transparent and symmetric RPC library";
    homepage = https://rpyc.readthedocs.org;
    license = licenses.mit;
  };

}
