{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unittestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyleri";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cesbit";
    repo = "pyleri";
    tag = "v${version}";
    hash = "sha256-5umFhP6t0Aezm4ecjg4ix18JhC0mm+bjyIZYqBHZMmI=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "pyleri" ];

  meta = {
    description = "Module to parse SiriDB";
    homepage = "https://github.com/cesbit/pyleri";
    changelog = "https://github.com/cesbit/pyleri/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
