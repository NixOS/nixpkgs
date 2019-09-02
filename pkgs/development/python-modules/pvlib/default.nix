{ stdenv, buildPythonPackage, fetchFromGitHub, numpy, pandas, pytz, six
, pytest, mock, pytest-mock }:

buildPythonPackage rec {
  pname = "pvlib";
  version = "0.6.1";

  # Use GitHub because PyPI release tarball doesn't contain the tests. See:
  # https://github.com/pvlib/pvlib-python/issues/473
  src = fetchFromGitHub{
    owner = "pvlib";
    repo = "pvlib-python";
    rev = "v${version}";
    sha256 = "17h7vz9s829qxnl4byr8458gzgiismrbrn5gl0klhfhwvc5kkdfh";
  };

  checkInputs = [ pytest mock pytest-mock ];
  propagatedBuildInputs = [ numpy pandas pytz six ];

  # Skip a few tests that try to access some URLs
  checkPhase = ''
    runHook preCheck
    pushd pvlib/test
    pytest . -k "not test_read_srml_dt_index and not test_read_srml_month_from_solardata"
    popd
    runHook postCheck
  '';

  meta = with stdenv.lib; {
    homepage = http://pvlib-python.readthedocs.io;
    description = "Simulate the performance of photovoltaic energy systems";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jluttine ];
  };
}
