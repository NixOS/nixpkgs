{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  jinja2,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "license";
  version = "0.1a3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hroncok";
    repo = "license";
    tag = "v${version}";
    hash = "sha256-T0J54Xq5cBn+zY9mV/rw9AFv97pnOJa+E5mmlkdhi4Y=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jinja2
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "license" ];

  meta = {
    description = "Python library that encapsulates free software licenses";
    homepage = "https://github.com/hroncok/license";
    changelog = "https://github.com/hroncok/license/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gigahawk
    ];
  };
}
