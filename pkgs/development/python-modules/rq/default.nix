{ lib, fetchFromGitHub, buildPythonPackage, isPy27, click, redis }:

buildPythonPackage rec {
  pname = "rq";
  version = "1.8.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "rq";
    repo = "rq";
    rev = "v${version}";
    sha256 = "1lfv3sb27v5xw3y67lirp877gg9230d28qmykxipvhcqwzqc2dqb";
  };

  # test require a running redis rerver, which is something we can't do yet
  doCheck = false;

  propagatedBuildInputs = [ click redis ];

  meta = with lib; {
    description = "A simple, lightweight library for creating background jobs, and processing them";
    homepage = "https://github.com/nvie/rq/";
    maintainers = with maintainers; [ mrmebelman ];
    license = licenses.bsd2;
  };
}

