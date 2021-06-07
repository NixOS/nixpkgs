{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
, pytestCheckHook
, setuptools
, packaging
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
  version = "2.3";

  # Tests not included in PyPI tarball
  src = fetchFromGitHub {
    owner = "lilydjwg";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ikqjlw6v7va69i8qskj1lf07ik84q4n3qgsb7khk520gv2ks3sx";
  };

  patches = [
    # Fix test that fail in sandbox build. See https://github.com/lilydjwg/nvchecker/pull/179
    (fetchpatch {
      url = "https://github.com/lilydjwg/nvchecker/commit/7366d82bfc3dcf231f7908e259bf2437cf7dafd5.patch";
      sha256 = "0pwrwa2wyy4i668lk2mqzzy6y3xi08mq3w520b4954kfm07g75a9";
    })
  ];

  nativeBuildInputs = [ installShellFiles docutils ];
  propagatedBuildInputs = [ setuptools packaging toml structlog appdirs tornado pycurl aiohttp ];
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

  meta = with lib; {
    homepage = "https://github.com/lilydjwg/nvchecker";
    description = "New version checker for software";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
