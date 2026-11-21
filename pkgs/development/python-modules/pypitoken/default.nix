{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  jsonschema,
  pymacaroons,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  typing-extensions,
  uv-dynamic-versioning,
}:

buildPythonPackage rec {
  pname = "pypitoken";
  version = "7.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ewjoachim";
    repo = "pypitoken";
    tag = version;
    hash = "sha256-0AtQH7fn4mgS+zH0RVla60u6kZb9H1xln6OsxDgSgIg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    pymacaroons
    jsonschema
    typing-extensions
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pypitoken" ];

  meta = {
    description = "Library for generating and manipulating PyPI tokens";
    homepage = "https://pypitoken.readthedocs.io/";
    changelog = "https://github.com/ewjoachim/pypitoken/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
