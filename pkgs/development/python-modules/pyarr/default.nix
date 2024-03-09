{ lib
, buildPythonPackage
, fetchFromGitHub
, overrides
, poetry-core
, pythonOlder
, requests
, pytestCheckHook
, types-requests
, responses
}:

buildPythonPackage rec {
  pname = "pyarr";
  version = "5.2.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "totaldebug";
    repo = "pyarr";
    rev = "refs/tags/v${version}";
    hash = "sha256-yvlDnAjmwDNdU1SWHGVrmoD3WHwrNt7hXoNNPo1hm1w=";
  };

  postPatch = ''
    # https://github.com/totaldebug/pyarr/pull/167
    substituteInPlace pyproject.toml \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    overrides
    requests
    types-requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [
    "pyarr"
  ];

  disabledTests = [
    # Tests require a running sonarr instance
    "test_add"
    "test_create"
    "test_del"
    "test_get"
    "test_lookup"
    "test_post"
    "test_upd"
  ];

  meta = with lib; {
    description = "Python client for Servarr API's (Sonarr, Radarr, Readarr, Lidarr)";
    homepage = "https://github.com/totaldebug/pyarr";
    changelog = "https://github.com/totaldebug/pyarr/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
