{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, numpy, pandas, pytz, six
, pytest, mock, pytest-mock, requests }:

buildPythonPackage rec {
  pname = "pvlib";
  version = "0.6.3";

  # Support for Python <3.5 dropped in 0.6.3 on June 1, 2019.
  disabled = pythonOlder "3.5";

  src = fetchPypi{
    inherit pname version;
    sha256 = "03nvgpmnscd7rh9jwm2h579zvriq5lva6rsdhb6jckpra5wjkn69";
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
    homepage = http://pvlib-python.readthedocs.io;
    description = "Simulate the performance of photovoltaic energy systems";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jluttine ];
  };
}
