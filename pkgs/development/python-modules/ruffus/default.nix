{
  gevent,
  buildPythonPackage,
  fetchFromGitHub,
  hostname,
  pytest,
  pythonAtLeast,
  lib,
  stdenv,
}:

buildPythonPackage rec {
  pname = "ruffus";
  version = "2.8.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "cgat-developers";
    repo = "ruffus";
    rev = "v${version}";
    sha256 = "0fnzpchwwqsy5h18fs0n90s51w25n0dx0l74j0ka6lvhjl5sxn4c";
  };

  propagatedBuildInputs = [ gevent ];

  nativeCheckInputs = [
    hostname
    pytest
  ];

  # tests very flaky & hang often on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;
  checkPhase =
    # https://docs.python.org/3/whatsnew/3.13.html#re
    lib.optionalString (pythonAtLeast "3.13") ''
      substituteInPlace ruffus/test/test_ruffus_utility.py \
        --replace-fail re.error re.PatternError
    ''
    # test files do indeed need to be executed separately
    + ''
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
    maintainers = [ ];
  };
}
