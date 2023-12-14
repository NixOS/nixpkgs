{ lib
, aiohttp
, platformdirs
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
  version = "2.12";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lilydjwg";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6mhVDC2jpIIOZeoKz4AxxU7jj8dqPVBKRWupbuY/T7E=";
  };

  nativeBuildInputs = [
    docutils
    installShellFiles
  ];

  propagatedBuildInputs = [
    aiohttp
    platformdirs
    packaging
    pycurl
    setuptools
    structlog
    tornado
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
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
    description = "New version checker for software";
    homepage = "https://github.com/lilydjwg/nvchecker";
    changelog = "https://github.com/lilydjwg/nvchecker/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
