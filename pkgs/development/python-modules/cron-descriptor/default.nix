{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "cron-descriptor";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Salamek";
    repo = "cron-descriptor";
    tag = version;
    hash = "sha256-EdOcAuheCV1I/dQu4FpQ3DYx4TfPy5TyuSSmivQGy3w=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cron_descriptor" ];

  meta = {
    description = "Library that converts cron expressions into human readable strings";
    homepage = "https://github.com/Salamek/cron-descriptor";
    changelog = "https://github.com/Salamek/cron-descriptor/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phaer ];
  };
}
