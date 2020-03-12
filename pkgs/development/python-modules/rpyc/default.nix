{ stdenv
, buildPythonPackage
, fetchFromGitHub
, nose
, plumbum
}:

buildPythonPackage rec {
  pname = "rpyc";
  version = "4.1.3";

  src = fetchFromGitHub {
    owner = "tomerfiliba";
    repo = pname;
    rev = version;
    sha256 = "145mi8p37x9cbfm5117g4ng7b5rmghjjwgm319qqhwgzvqg3y4j9";
  };

  propagatedBuildInputs = [ plumbum ];

  checkInputs = [ nose ];
  checkPhase = ''
    cd tests
    # some tests have added complexities and some tests attempt network use
    nosetests -I test_deploy -I test_gevent_server -I test_ssh -I test_registry
  '';

  meta = with stdenv.lib; {
    description = "Remote Python Call (RPyC), a transparent and symmetric RPC library";
    homepage = https://rpyc.readthedocs.org;
    license = licenses.mit;
  };

}
