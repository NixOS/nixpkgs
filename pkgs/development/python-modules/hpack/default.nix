{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "hpack";
  version = "4.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-hyper";
    repo = "hpack";
    rev = "v${version}";
    hash = "sha256-gZe/ABRLXoBAeH/mp/yIgDj56jalyiYgs4EP2qK17Ig=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [ "hpack" ];

  meta = {
    changelog = "https://github.com/python-hyper/hpack/blob/${src.rev}/CHANGELOG.rst";
    description = "Pure-Python HPACK header compression";
    homepage = "https://github.com/python-hyper/hpack";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
