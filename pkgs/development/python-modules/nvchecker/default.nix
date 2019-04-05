{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, pytest, setuptools, structlog, pytest-asyncio, pytest_xdist, flaky, tornado, pycurl }:

buildPythonPackage rec {
  pname = "nvchecker";
  version = "1.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0v340wkq4sn9pvcpjh076l8mcqkn3nrn7if8p6iysk02bjxvknbv";
  };

  propagatedBuildInputs = [ setuptools structlog tornado pycurl ];
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
