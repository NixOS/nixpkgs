{
  buildPythonPackage,
  cacert,
  fetchFromGitHub,
  lib,
  loguru,
  pyreqwest,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  respx,
  setuptools,
  typer,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "prowlpy";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OMEGARAZER";
    repo = "prowlpy";
    tag = "v${version}";
    hash = "sha256-S+hhZndOb5O9okrrnXGt7D0N4VRIThbMN1LYVPGzFy8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyreqwest
    xmltodict
  ];

  optional-dependencies = {
    cli = [
      loguru
      typer
    ];
  };

  pythonImportsCheck = [ "prowlpy" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    respx
  ]
  ++ lib.concatAttrValues optional-dependencies;

  preCheck = ''
    # Without this pyreqwest fails with
    #     unexpected error: No CA certificates were loaded from the system
    export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
  '';

  # tests fail without this
  pytestFlags = [ "-v" ];

  meta = {
    changelog = "https://github.com/OMEGARAZER/prowlpy/blob/${src.tag}/CHANGELOG.md";
    description = "Send push notifications to iPhones using the Prowl API";
    homepage = "https://github.com/OMEGARAZER/prowlpy";
    license = lib.licenses.gpl3Only;
    mainProgram = "prowlpy";
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
