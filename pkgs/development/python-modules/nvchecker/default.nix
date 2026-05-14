{
  lib,
  awesomeversion,
  buildPythonPackage,
  docutils,
  fetchFromGitHub,
  flaky,
  installShellFiles,
  jq,
  lxml,
  nix-update-script,
  packaging,
  platformdirs,
  pycurl,
  pytest-asyncio,
  pytestCheckHook,
  pytest-httpbin,
  pythonOlder,
  setuptools,
  structlog,
  tornado,
  zstandard,
}:

buildPythonPackage rec {
  pname = "nvchecker";
  version = "2.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lilydjwg";
    repo = "nvchecker";
    tag = "v${version}";
    hash = "sha256-udwflm3C7C6Q7rSA0x0+8uf1F5quy2okf2IyZqKtA3E=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ setuptools ];

  nativeBuildInputs = [
    docutils
    installShellFiles
  ];

  dependencies = [
    structlog
    platformdirs
    tornado
    pycurl
  ];

  optional-dependencies = {
    # vercmp = [ pyalpm ];
    awesomeversion = [ awesomeversion ];
    pypi = [ packaging ];
    htmlparser = [ lxml ];
    rpmrepo = [ lxml ] ++ lib.optionals (pythonOlder "3.14") [ zstandard ];
    jq = [ jq ];
  };

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

  disabledTestMarks = [ "needs_net" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "New version checker for software";
    homepage = "https://github.com/lilydjwg/nvchecker";
    changelog = "https://github.com/lilydjwg/nvchecker/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mdaniels5757 ];
  };
}
