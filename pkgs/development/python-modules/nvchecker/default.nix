{ lib
, aiohttp
, appdirs
, buildPythonPackage
, docutils
, fetchFromGitHub
, flaky
, installShellFiles
, packaging
, pycurl
, pytest-asyncio
, pytest-httpbin
, pytestCheckHook
, pythonOlder
, setuptools
, structlog
, tomli
, tornado
}:

buildPythonPackage rec {
  pname = "nvchecker";
  version = "2.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lilydjwg";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NxHeHT56JCu8Gn/B4IcvPtgGcWH8V9CUQkJeKFcGk/Q=";
  };

  nativeBuildInputs = [
    docutils
    installShellFiles
  ];

  propagatedBuildInputs = [
    aiohttp
    appdirs
    packaging
    pycurl
    setuptools
    structlog
    tomli
    tornado
  ];

  checkInputs = [
    flaky
    pytest-asyncio
    pytest-httpbin
    pytestCheckHook
  ];

  postBuild = ''
    patchShebangs docs/myrst2man.py
    make -C docs man
  '';

  postInstall = ''
    installManPage docs/_build/man/nvchecker.1
  '';

  pythonImportsCheck = [
    "nvchecker"
  ];

  pytestFlagsArray = [
    "-m 'not needs_net'"
  ];

  meta = with lib; {
    homepage = "https://github.com/lilydjwg/nvchecker";
    description = "New version checker for software";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
