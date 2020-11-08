{ stdenv, fetchFromGitHub, buildPythonPackage, isPy27, click, redis }:

buildPythonPackage rec {
  pname = "rq";
  version = "1.5.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "rq";
    repo = "rq";
    rev = "v${version}";
    sha256 = "0i7yyw828wdvl7ap4gb7jhm4p94502is3xxrgrdgwwp0l1rac004";
  };

  # test require a running redis rerver, which is something we can't do yet
  doCheck = false;

  requiredPythonModules = [ click redis ];

  meta = with stdenv.lib; {
    description = "A simple, lightweight library for creating background jobs, and processing them";
    homepage = "https://github.com/nvie/rq/";
    maintainers = with maintainers; [ mrmebelman ];
    license = licenses.bsd2;
  };
}

