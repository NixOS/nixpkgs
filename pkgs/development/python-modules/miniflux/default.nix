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
  version = "1.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "miniflux";
    repo = "python-client";
    tag = version;
    hash = "sha256-RnND/NBTpmqT1UubGQLM7NVpIYKvue7CnRXWG0scqPo=";
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
