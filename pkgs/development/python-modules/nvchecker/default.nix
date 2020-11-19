{ stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, setuptools
, toml
, structlog
, appdirs
, pytest-asyncio
, flaky
, tornado
, pycurl
, aiohttp
, pytest-httpbin
, docutils
, installShellFiles
}:

buildPythonPackage rec {
  pname = "nvchecker";
  version = "2.2";

  # Tests not included in PyPI tarball
  src = fetchFromGitHub {
    owner = "lilydjwg";
    repo = pname;
    rev = "v${version}";
    sha256 = "0b17pikqyxcsid69lwnjl44n8z46ydjmxxdnbzasfdl7r83l7ijr";
  };

  nativeBuildInputs = [ installShellFiles docutils ];
  propagatedBuildInputs = [ setuptools toml structlog appdirs tornado pycurl aiohttp ];
  checkInputs = [ pytestCheckHook pytest-asyncio flaky pytest-httpbin ];

  disabled = pythonOlder "3.7";

  postBuild = ''
    patchShebangs docs/myrst2man.py
    make -C docs man
  '';

  postInstall = ''
    installManPage docs/_build/man/nvchecker.1
  '';

  pytestFlagsArray = [ "-m 'not needs_net'" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/lilydjwg/nvchecker";
    description = "New version checker for software";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
