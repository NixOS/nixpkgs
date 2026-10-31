{
  lib,
  addBinToPathHook,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  ipython,
  pytestCheckHook,
  setuptools,
  sh,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-dotenv";
  version = "1.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theskumar";
    repo = "python-dotenv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nwGqNdc34SblZXamtzpZKVUJNbgXlGSnPFfYOsxqMWU=";
  };

  build-system = [ setuptools ];

  optional-dependencies.cli = [ click ];

  nativeCheckInputs = [
    addBinToPathHook
    ipython
    pytestCheckHook
    sh
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "dotenv" ];

  meta = {
    changelog = "https://github.com/theskumar/python-dotenv/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Add .env support to your django/flask apps in development and deployments";
    mainProgram = "dotenv";
    homepage = "https://github.com/theskumar/python-dotenv";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ erikarvstedt ];
  };
})
