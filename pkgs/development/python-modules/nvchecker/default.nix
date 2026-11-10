{
  lib,
  awesomeversion,
  buildPythonPackage,
  cacert,
  docutils,
  dulwich,
  fetchFromGitHub,
  flaky,
  installShellFiles,
  jq,
  lxml,
  nix-update-script,
  packaging,
  platformdirs,
  pycurl,
  pygit2,
  pytest-asyncio,
  pytestCheckHook,
  pytest-httpbin,
  pytest-rerunfailures,
  pythonOlder,
  setuptools,
  structlog,
  tornado,
  zstandard,
}:

buildPythonPackage (finalAttrs: {
  pname = "nvchecker";
  version = "2.22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lilydjwg";
    repo = "nvchecker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QNcL1zlcFkQgJwrBnk9ubDPUyNYvAsaZ0kZHl71AqEU=";
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
    # portage = [ portage ];
    pypi = [ packaging ];
    htmlparser = [ lxml ];
    rpmrepo = [ lxml ] ++ lib.optionals (pythonOlder "3.14") [ zstandard ];
    jq = [ jq ];
    git_pygit2 = [ pygit2 ];
    git_dulwich = [ dulwich ];
  };

  env = lib.optionalAttrs finalAttrs.doInstallCheck {
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  nativeCheckInputs = [
    flaky
    pytest-asyncio
    pytest-httpbin
    pytest-rerunfailures
    pytestCheckHook
  ]
  ++ builtins.concatLists (builtins.attrValues finalAttrs.passthru.optional-dependencies);

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
    changelog = "https://github.com/lilydjwg/nvchecker/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mdaniels5757 ];
  };
})
