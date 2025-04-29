{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mypy-extensions,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  ruamel-yaml,
  schema-salad,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cwl-upgrader";
  version = "1.2.12";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "common-workflow-language";
    repo = "cwl-upgrader";
    tag = "v${version}";
    hash = "sha256-cfEd1XAu31u+NO27d3RNA5lhCpRpYK8NeaCxhQ/1GNU=";
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

  meta = with lib; {
    description = "Library to upgrade CWL syntax to a newer version";
    mainProgram = "cwl-upgrader";
    homepage = "https://github.com/common-workflow-language/cwl-upgrader";
    changelog = "https://github.com/common-workflow-language/cwl-upgrader/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
