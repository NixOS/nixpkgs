{ stdenv, buildPythonPackage, fetchPypi, pythonOlder, pytestCheckHook, setuptools, structlog, pytest-asyncio, flaky, tornado, pycurl, aiohttp, pytest-httpbin }:

buildPythonPackage rec {
  pname = "nvchecker";
  version = "1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01be0e5587d346ad783b4b2dc45bd8eefe477081b33fff18cc2fdea58c2a38ef";
  };

  propagatedBuildInputs = [ setuptools structlog tornado pycurl aiohttp ];
  checkInputs = [ pytestCheckHook pytest-asyncio flaky pytest-httpbin ];

  disabled = pythonOlder "3.5";

  pytestFlagsArray = [ "-m 'not needs_net'" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/lilydjwg/nvchecker";
    description = "New version checker for software";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
