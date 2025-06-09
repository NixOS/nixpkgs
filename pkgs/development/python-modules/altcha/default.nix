{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "altcha";
  version = "0.1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "altcha-org";
    repo = "altcha-lib-py";
    tag = "v${version}";
    hash = "sha256-54v8c/yp5zhJU151UaTxeJ1FDmbPs2TcfxomrMhFVZc=";
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
