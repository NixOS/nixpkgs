{ stdenv
, buildPythonPackage
, fetchFromGitHub
, pytest
, celery
}:

buildPythonPackage rec {
  pname = "celery-batches";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "percipient";
    repo = pname;
    rev = "v${version}";
    sha256 = "13j4m9k4hf23118yv86999kq80i0pkz6bar4g1gp8yr6nqgy3dhi";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ celery ];

  checkPhase = "py.test";

  meta = with stdenv.lib; {
    homepage = https://github.com/percipient/celery-batches;
    description = "Celery Batches allows processing of multiple Celery task requests together";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jtojnar ];
  };
}
