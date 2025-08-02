{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  configobj,
  pytestCheckHook,
  pyyaml,
  setuptools,
  sphinx,
}:

buildPythonPackage rec {
  pname = "everett";
  version = "3.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "willkg";
    repo = "everett";
    tag = "v${version}";
    hash = "sha256-olYxUbsKaL7C5UTAPwW+EufjbWbbHZdZcQ/lfogNJrg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    configobj
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    sphinx
  ];

  pythonImportsCheck = [ "everett" ];

  meta = {
    description = "Python configuration library for your app";
    homepage = "https://github.com/willkg/everett";
    changelog = "https://github.com/willkg/everett/releases/tag/${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jherland ];
  };
}
