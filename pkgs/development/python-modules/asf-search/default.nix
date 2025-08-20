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
  version = "8.1.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "asfadmin";
    repo = "Discovery-asf_search";
    tag = "v${version}";
    hash = "sha256-9NyBDpCIsRBPN2965SR106h6hxwML7kXv6sY3YlPseA=";
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
    changelog = "https://github.com/asfadmin/Discovery-asf_search/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bzizou ];
  };
}
