{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, setuptools
, packaging
, tomli
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
  version = "2.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lilydjwg";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OPUqkHLG8PUlD5NP7q/BpKUvmAA8Jk1NvsPPVbImv0A=";
  };

  nativeBuildInputs = [
    installShellFiles
    docutils
  ];
  
  propagatedBuildInputs = [
    setuptools
    packaging
    tomli
    structlog
    appdirs
    tornado
    pycurl
    aiohttp
  ];

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
    flaky
    pytest-httpbin
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
