{ stdenv, buildPythonPackage, fetchFromGitHub, pythonOlder, pytestCheckHook, setuptools, toml, structlog, appdirs, pytest-asyncio, flaky, tornado, pycurl, aiohttp, pytest-httpbin }:

buildPythonPackage rec {
  pname = "nvchecker";
  version = "2.0";

  # Tests not included in PyPI tarball
  src = fetchFromGitHub {
    owner = "lilydjwg";
    repo = pname;
    rev = "v${version}";
    sha256 = "13wa95pvivbyshq3ys12iyvn8wlyzxfia8l6xh3fd46a2cs9x9g7";
  };

  propagatedBuildInputs = [ setuptools toml structlog appdirs tornado pycurl aiohttp ];
  checkInputs = [ pytestCheckHook pytest-asyncio flaky pytest-httpbin ];

  disabled = pythonOlder "3.7";

  pytestFlagsArray = [ "-m 'not needs_net'" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/lilydjwg/nvchecker";
    description = "New version checker for software";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
