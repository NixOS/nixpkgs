{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  ruamel-yaml,
  typing-extensions,
  setuptools-scm,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pydantic-yaml";
  version = "1.6.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "NowanIlfideme";
    repo = "pydantic-yaml";
    tag = "v${version}";
    hash = "sha256-n5QWVHgYAg+Ad7Iv6CBSRQcl8lv4ZtcFMiC2ZHyi414=";
  };

  postPatch = ''
    substituteInPlace src/pydantic_yaml/version.py \
      --replace-fail "0.0.0" "${version}"
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    pydantic
    ruamel-yaml
    typing-extensions
  ];

  pythonImportsCheck = [ "pydantic_yaml" ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  meta = {
    description = "Small helper library that adds some YAML capabilities to pydantic";
    homepage = "https://github.com/NowanIlfideme/pydantic-yaml";
    changelog = "https://github.com/NowanIlfideme/pydantic-yaml/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}
