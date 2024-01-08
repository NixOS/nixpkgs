{ lib
, buildPythonPackage
, fetchPypi
, overrides
, poetry-core
, pythonOlder
, requests
, types-requests
}:

buildPythonPackage rec {
  pname = "pyarr";
  version = "5.2.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jlcc9Kj1MYSsnvJkKZXXWWJVDx3KIuojjbGtl8kDUpw=";
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

  pythonImportsCheck = [
    "pyarr"
  ];

  meta = with lib; {
    description = "Python client for Servarr API's (Sonarr, Radarr, Readarr, Lidarr)";
    homepage = "https://github.com/totaldebug/pyarr";
    changelog = "https://github.com/totaldebug/pyarr/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
