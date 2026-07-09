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

buildPythonPackage (finalAttrs: {
  pname = "prowlpy";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OMEGARAZER";
    repo = "prowlpy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-92r1E/dsXLRzaLXQdahXAPCmSG4T1Ihh/eDFDG3GlmY=";
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
    cacert
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    respx
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  # tests fail without this
  pytestFlags = [ "-v" ];

  meta = {
    changelog = "https://github.com/OMEGARAZER/prowlpy/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Send push notifications to iPhones using the Prowl API";
    homepage = "https://github.com/OMEGARAZER/prowlpy";
    license = lib.licenses.gpl3Only;
    mainProgram = "prowlpy";
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
