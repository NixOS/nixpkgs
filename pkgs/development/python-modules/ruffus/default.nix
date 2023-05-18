{ gevent
, buildPythonPackage
, fetchFromGitHub
, hostname
, pytest
, lib, stdenv
}:

buildPythonPackage rec {
  pname = "ruffus";
  version = "2.8.4";

  src = fetchFromGitHub {
    owner = "cgat-developers";
    repo = pname;
    rev = "v${version}";
    sha256 = "0fnzpchwwqsy5h18fs0n90s51w25n0dx0l74j0ka6lvhjl5sxn4c";
  };

  propagatedBuildInputs = [ gevent ];

  nativeCheckInputs = [
    hostname
    pytest
  ];

  # tests very flaky & hang often on darwin
  doCheck = !stdenv.isDarwin;
  # test files do indeed need to be executed separately
  checkPhase = ''
    pushd ruffus/test
    rm test_with_logger.py  # spawns 500 processes
    for f in test_*.py ; do
      HOME=$TMPDIR pytest -v --disable-warnings $f
    done
    popd
  '';
  pythonImportsCheck = [ "ruffus" ];

  meta = with lib; {
    description = "Light-weight Python Computational Pipeline Management";
    homepage = "http://www.ruffus.org.uk";
    license = licenses.mit;
    maintainers = [ maintainers.kiwi ];
  };
}

