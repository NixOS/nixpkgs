{
  lib,
  buildPythonPackage,
  dateparser,
  defusedxml,
  fetchFromGitHub,
  importlib-metadata,
  numpy,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  pytz,
  remotezip,
  requests-mock,
  requests,
  setuptools-scm,
  shapely,
  tenacity,
}:

buildPythonPackage rec {
  pname = "asf-search";
  version = "8.1.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "asfadmin";
    repo = "Discovery-asf_search";
    tag = "v${version}";
    hash = "sha256-/EQpeTFGDbJnC/HnnK9v3eaz1xVvv3i0bSIZ27z9GVU=";
  };

  pythonRelaxDeps = [ "tenacity" ];

  build-system = [ setuptools-scm ];

  dependencies = [
    dateparser
    importlib-metadata
    numpy
    python-dateutil
    pytz
    remotezip
    requests
    shapely
  ];

  nativeCheckInputs = [
    defusedxml
    pytestCheckHook
    requests-mock
    tenacity
  ];

  pythonImportsCheck = [ "asf_search" ];

  meta = with lib; {
    description = "Python wrapper for the ASF SearchAPI";
    homepage = "https://github.com/asfadmin/Discovery-asf_search";
    changelog = "https://github.com/asfadmin/Discovery-asf_search/blob/${src.tag}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bzizou ];
  };
}
