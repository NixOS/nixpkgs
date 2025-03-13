{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  packaging,
  requests,
  urllib3,
}:

buildPythonPackage rec {
  pname = "qbittorrent-api";
  version = "2025.2.0";
  pyproject = true;

  src = fetchPypi {
    pname = "qbittorrent_api";
    inherit version;
    hash = "sha256-e7MMiDxgJxR72dMBqyZSXAsrL067ACs83WNszr+z0ms=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    packaging
    requests
    urllib3
  ];

  # Tests require internet access
  doCheck = false;

  pythonImportsCheck = [ "qbittorrentapi" ];

  meta = {
    description = "Python client implementation for qBittorrent's Web API";
    homepage = "https://github.com/rmartin16/qbittorrent-api";
    changelog = "https://github.com/rmartin16/qbittorrent-api/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ savyajha ];
  };
}
