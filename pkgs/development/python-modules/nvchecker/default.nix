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
  tomli,
  tornado,
  zstandard,
}:

buildPythonPackage rec {
  pname = "nvchecker";
  version = "2.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lilydjwg";
    repo = "nvchecker";
    tag = "v${version}";
    hash = "sha256-C8g8uhuWOl3zPCjTaGs21yJ8k3tmvZE8U9LzSXoDSxE=";
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
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ];

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
