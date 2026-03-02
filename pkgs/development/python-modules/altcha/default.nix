{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "altcha";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "altcha-org";
    repo = "altcha-lib-py";
    tag = "v${version}";
    hash = "sha256-N30luHhGFkd+XvVKhVnR6degEf0Nm/K/GEaqoEEuZMU=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "altcha" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Lightweight Python library for creating and verifying ALTCHA challenges";
    homepage = "https://github.com/altcha-org/altcha-lib-py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ erictapen ];
  };
}
