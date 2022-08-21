{ lib, fetchFromGitHub, buildPythonPackage, isPy27, click, redis }:

buildPythonPackage rec {
  pname = "rq";
  version = "1.11";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "rq";
    repo = "rq";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-fv+b5WmODaQkd8T+O8MuJ+XVC3dQ5hZwxMHtBBuqQ7Y=";
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

