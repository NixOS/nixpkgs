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
  version = "2.11";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lilydjwg";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-b/EGn26gTpnYuy2h6shnJI1dRwhl41eKJHzDJoFG1YI=";
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
    tomli
    tornado
  ];

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
    homepage = "https://github.com/lilydjwg/nvchecker";
    description = "New version checker for software";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
