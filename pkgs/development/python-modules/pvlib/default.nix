{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, numpy, pandas, pytz, six
, pytest, mock, pytest-mock, requests }:

buildPythonPackage rec {
  pname = "pvlib";
  version = "0.7.0";

  # Support for Python <3.5 dropped in 0.6.3 on June 1, 2019.
  disabled = pythonOlder "3.5";

  src = fetchPypi{
    inherit pname version;
    sha256 = "ee935ba52f1d4a514cc3baa743db0377af732952faf800f20ffd8071fa2107c2";
  };

  checkInputs = [ pytest mock pytest-mock ];
  propagatedBuildInputs = [ numpy pandas pytz six requests ];

  # Skip a few tests that try to access some URLs
  checkPhase = ''
    runHook preCheck
    pushd pvlib/test
    pytest . -k "not test_read_srml_dt_index and not test_read_srml_month_from_solardata and not test_get_psm3"
    popd
    runHook postCheck
  '';

  meta = with stdenv.lib; {
    homepage = https://pvlib-python.readthedocs.io;
    description = "Simulate the performance of photovoltaic energy systems";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jluttine ];
  };
}
