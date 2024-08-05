{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
  djangorestframework,
  filetype,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "drf-extra-fields";
  version = "3.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hipo";
    repo = "drf-extra-fields";
    rev = "v${version}";
    hash = "sha256-Ym4vnZ/t0ZdSxU53BC0ducJl1YiTygRSWql/35PNbOU";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    djangorestframework
    filetype
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "drf_extra_fields" ];

  meta = {
    description = "Extra Fields for Django Rest Framework";
    homepage = "https://github.com/Hipo/drf-extra-fields";
    changelog = "https://github.com/Hipo/drf-extra-fields/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
