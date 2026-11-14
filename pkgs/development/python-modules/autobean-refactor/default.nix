{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  lark,
  mako,
  nix-update-script,
  pdm-backend,
  pytest-benchmark,
  pytest-cov-stub,
  pytestCheckHook,
  stringcase,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "autobean-refactor";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SEIAROTg";
    repo = "autobean-refactor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VNqyr46yqOs5ynEfpD/FJKRljEpb9emqyNlL+w8jGmo=";
  };

  build-system = [
    pdm-backend
  ];

  dependencies = [
    lark
    typing-extensions
  ];

  nativeCheckInputs = [
    mako
    pytest-benchmark
    pytest-cov-stub
    pytestCheckHook
    stringcase
  ];

  pythonImportsCheck = [ "autobean_refactor" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://autobean-refactor.readthedocs.io";
    description = "Ergonomic and losess beancount manipulation library";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})
