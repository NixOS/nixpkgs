{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyhamcrest,
  pytestCheckHook,
  setuptools,
  toml,
}:

buildPythonPackage (finalAttrs: {
  pname = "confight";
  version = "2.0.0-2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Avature";
    repo = "confight";
    tag = finalAttrs.version;
    hash = "sha256-FudWRHk3rZGRSAE/yZr792CgD5i47ZwLlpgKUdy+5lQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ toml ];

  nativeCheckInputs = [
    pyhamcrest
    pytestCheckHook
  ];

  pythonImportsCheck = [ "confight" ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  disabledTests = [
    # CLI output issue
    "test_it_should_print_help"
    "test_it_should_show_config"
  ];

  meta = {
    description = "Python context manager for managing pid files";
    homepage = "https://github.com/Avature/confight";
    changelog = "https://github.com/Avature/confight/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mkg20001 ];
    mainProgram = "confight";
  };
})
