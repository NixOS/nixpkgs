{ lib
, fetchFromGitHub
, buildPythonPackage
, fetchpatch

# build-system
, poetry-core

# dependencies
, overrides
, requests
, types-requests
}:

buildPythonPackage rec {
  pname = "pyarr";
  version = "5.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "totaldebug";
    repo = "pyarr";
    rev = "refs/tags/v${version}";
    hash = "sha256-yvlDnAjmwDNdU1SWHGVrmoD3WHwrNt7hXoNNPo1hm1w=";
  };

  patches = [
    (fetchpatch {
      # fix build hook specification
      url = "https://github.com/totaldebug/pyarr/commit/e0aaf53fdb3ab2f60c27c1ec74ce361eca5278d6.patch";
      hash = "sha256-vD7to465/tviY25D+FUjsg6mJ+N8ZP6qJbWCw9hx/84=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    overrides
    requests
    types-requests
  ];

  pythonImportsCheck = [
    "pyarr"
  ];

  doCheck = false; # requires running *arr instances

  meta = with lib; {
    description = "Python client for Servarr API's (Sonarr, Radarr, Readarr, Lidarr)";
    homepage = "https://github.com/totaldebug/pyarr";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
