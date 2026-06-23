{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mypy-extensions,
  pytest-xdist,
  pytestCheckHook,
  ruamel-yaml,
  schema-salad,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "cwl-upgrader";
  version = "1.2.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "common-workflow-language";
    repo = "cwl-upgrader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7gmwz3a3IYky/Eof4fnSp3P5oSAko91drcX7i9CwZUY=";
  };

  postPatch = ''
    # Version detection doesn't work for schema_salad
    substituteInPlace pyproject.toml \
      --replace '"schema_salad",' ""
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    mypy-extensions
    ruamel-yaml
    schema-salad
  ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cwlupgrader" ];

  meta = {
    description = "Library to upgrade CWL syntax to a newer version";
    homepage = "https://github.com/common-workflow-language/cwl-upgrader";
    changelog = "https://github.com/common-workflow-language/cwl-upgrader/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cwl-upgrader";
  };
})
