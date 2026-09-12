{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "dictdiffer";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inveniosoftware";
    repo = "dictdiffer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5jYfkqyU3LrYDy+U9+McOYXyutp8gZSeCmx99NsLYgo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--isort --pydocstyle" ""
  '';

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "dictdiffer" ];

  meta = {
    description = "Module to diff and patch dictionaries";
    homepage = "https://github.com/inveniosoftware/dictdiffer";
    changelog = "https://github.com/inveniosoftware/dictdiffer/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
