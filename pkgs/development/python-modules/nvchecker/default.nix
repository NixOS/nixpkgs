{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, pytest, setuptools, structlog, pytest-asyncio, flaky, tornado, pycurl, pytest-httpbin }:

buildPythonPackage rec {
  pname = "nvchecker";
  version = "1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0973f7c3ea5ad65fb19837e8915882a9f2c2f21f5c2589005478697391fea2fd";
  };

  propagatedBuildInputs = [ setuptools structlog tornado pycurl ];
  checkInputs = [ pytest pytest-asyncio flaky pytest-httpbin ];

  # disable `test_ubuntupkg` because it requires network
  checkPhase = ''
    py.test -m "not needs_net" --ignore=tests/test_ubuntupkg.py
  '';

  disabled = pythonOlder "3.5";

  meta = with stdenv.lib; {
    homepage = https://github.com/lilydjwg/nvchecker;
    description = "New version checker for software";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
