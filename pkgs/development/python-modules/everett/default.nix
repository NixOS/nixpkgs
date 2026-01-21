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
  version = "3.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "willkg";
    repo = "everett";
    tag = "v${version}";
    hash = "sha256-5cjPV2pt2x8RmaGWTRWeX3Nb1QeDd7245FZ0tEmYCSk=";
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
    changelog = "https://github.com/willkg/everett/releases/tag/${src.tag}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jherland ];
  };
}
