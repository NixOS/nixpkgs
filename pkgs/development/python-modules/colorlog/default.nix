{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "colorlog";
  version = "6.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "borntyping";
    repo = "python-colorlog";
    tag = "v${version}";
    hash = "sha256-vb7OzIVcEIfnhJGpO0DgeEdhL6NCKlrynoNMxNp8Yg4=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "colorlog" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/borntyping/python-colorlog/releases/tag/${src.tag}";
    description = "Log formatting with colors";
    homepage = "https://github.com/borntyping/python-colorlog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
