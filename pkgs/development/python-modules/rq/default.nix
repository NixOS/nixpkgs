{ lib, fetchFromGitHub, buildPythonPackage, isPy27, click, redis }:

buildPythonPackage rec {
  pname = "rq";
  version = "1.10.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "rq";
    repo = "rq";
    rev = "v${version}";
    sha256 = "1f4fi1rvn97d2b524q45k6s10b007pr23k0mf44q7hy8q4vnjmh5";
  };

  # test require a running redis rerver, which is something we can't do yet
  doCheck = false;

  pythonImportsCheck = [ "rq" ];

  propagatedBuildInputs = [ click redis ];

  meta = with lib; {
    description = "A simple, lightweight library for creating background jobs, and processing them";
    homepage = "https://github.com/nvie/rq/";
    maintainers = with maintainers; [ mrmebelman ];
    license = licenses.bsd2;
  };
}

