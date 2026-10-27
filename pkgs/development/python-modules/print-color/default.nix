{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "print-color";
  version = "0.4.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xy3";
    repo = "print-color";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WzWButpFc+YHQNjd7+t5MHgAa8W9nSyWfTCd9zmnD6s=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "print_color" ];

  meta = {
    description = "Module to print color messages in the terminal";
    homepage = "https://github.com/xy3/print-color";
    changelog = "https://github.com/xy3/print-color/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
