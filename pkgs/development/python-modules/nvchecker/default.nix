{
  lib,
  platformdirs,
  buildPythonPackage,
  docutils,
  fetchFromGitHub,
  flaky,
  installShellFiles,
  pycurl,
  pytest-asyncio,
  pytest-httpbin,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  structlog,
  tomli,
  tornado,
  awesomeversion,
  packaging,
  lxml,
}:

buildPythonPackage rec {
  pname = "nvchecker";
  version = "2.16";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "lilydjwg";
    repo = "nvchecker";
    tag = "v${version}";
    hash = "sha256-HdL3BnjQZzKXtjhQqDst6dJH82g3BONFsGUnwzDMRDA=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    docutils
    installShellFiles
  ];

  propagatedBuildInputs = [
    structlog
    platformdirs
    tornado
    pycurl
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

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

  pythonImportsCheck = [ "nvchecker" ];

  pytestFlagsArray = [ "-m 'not needs_net'" ];

  optional-dependencies = {
    # vercmp = [ pyalpm ];
    awesomeversion = [ awesomeversion ];
    pypi = [ packaging ];
    htmlparser = [ lxml ];
  };

  meta = {
    description = "New version checker for software";
    homepage = "https://github.com/lilydjwg/nvchecker";
    changelog = "https://github.com/lilydjwg/nvchecker/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
