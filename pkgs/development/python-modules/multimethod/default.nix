{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "multimethod";
  version = "2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "coady";
    repo = "multimethod";
    tag = "v${version}";
    hash = "sha256-tv+j1E8/Z0ohbfWWc1hz2W7haUYprQ8DaU6oJSllEcc=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "multimethod" ];

  meta = {
    description = "Multiple argument dispatching";
    homepage = "https://coady.github.io/multimethod/";
    changelog = "https://github.com/coady/multimethod/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
