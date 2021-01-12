{ lib, stdenv
, buildPythonPackage
, fetchFromGitHub
, nose
, plumbum
}:

buildPythonPackage rec {
  pname = "rpyc";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "tomerfiliba";
    repo = pname;
    rev = version;
    sha256 = "1g75k4valfjgab00xri4pf8c8bb2zxkhgkpyy44fjk7s5j66daa1";
  };

  propagatedBuildInputs = [ plumbum ];

  checkInputs = [ nose ];
  checkPhase = ''
    cd tests
    # some tests have added complexities and some tests attempt network use
    nosetests -I test_deploy -I test_gevent_server -I test_ssh -I test_registry
  '';

  meta = with lib; {
    description = "Remote Python Call (RPyC), a transparent and symmetric RPC library";
    homepage = "https://rpyc.readthedocs.org";
    license = licenses.mit;
  };

}
