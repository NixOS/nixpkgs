{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, pytest, setuptools, structlog, pytest-asyncio, pytest_xdist, flaky, tornado }:

buildPythonPackage rec {
  pname = "nvchecker";
  version = "1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nk9ff26s5r6v5v7w4l9110qi5kmhllvwk5kh20zyyhdvxv72m3i";
  };

  # tornado is not present in the tarball setup.py but is required by the executable
  propagatedBuildInputs = [ setuptools structlog tornado ];
  checkInputs = [ pytest pytest-asyncio pytest_xdist flaky ];

  # Disable tests for now, because our version of pytest seems to be too new
  # https://github.com/lilydjwg/nvchecker/commit/42a02efec84824a073601e1c2de30339d251e4c7
  doCheck = false;

  checkPhase = ''
    py.test
  '';

  disabled = pythonOlder "3.5";

  meta = with stdenv.lib; {
    homepage = https://github.com/lilydjwg/nvchecker;
    description = "New version checker for software";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
