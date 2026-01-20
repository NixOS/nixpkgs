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
  version = "9.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asfadmin";
    repo = "Discovery-asf_search";
    tag = "v${version}";
    hash = "sha256-1ZJsVcbqvB0DpcVyCWaEdYEnDXDDIupiprcIZlRCWDo=";
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

  meta = {
    description = "Python wrapper for the ASF SearchAPI";
    homepage = "https://github.com/asfadmin/Discovery-asf_search";
    changelog = "https://github.com/asfadmin/Discovery-asf_search/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bzizou ];
  };
}
