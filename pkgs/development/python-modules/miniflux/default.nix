{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "miniflux";
  version = "1.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "miniflux";
    repo = "python-client";
    tag = version;
    hash = "sha256-SCam8WiQH0cOUcqMMvhNDaNPGs7hi1RP4x4eoa5WIa4=";
  };
  build-system = [ setuptools ];

  dependencies = [ requests ];

  pythonImportsCheck = [ "miniflux" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Miniflux Python API Client";
    homepage = "https://github.com/miniflux/python-client";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wariuccio ];
  };
}
