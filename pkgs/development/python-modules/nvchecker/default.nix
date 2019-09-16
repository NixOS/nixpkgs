{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, pytest, setuptools, structlog, pytest-asyncio, flaky, tornado, pycurl }:

buildPythonPackage rec {
  pname = "nvchecker";
  version = "1.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6276ed2a897a30ccd71bfd7cf9e6b7842f37f3d5a86d7a70fe46f437c62b1875";
  };

  propagatedBuildInputs = [ setuptools structlog tornado pycurl ];
  checkInputs = [ pytest pytest-asyncio flaky ];

  # requires network access
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
