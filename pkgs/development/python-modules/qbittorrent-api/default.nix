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

buildPythonPackage (finalAttrs: {
  pname = "qbittorrent-api";
  version = "2026.10.0";
  pyproject = true;

  src = fetchPypi {
    pname = "qbittorrent_api";
    inherit (finalAttrs) version;
    hash = "sha256-K0yaa+L2R2w10QvbFJ81fwN4GnJQbp3sorzO+MMn6Xs=";
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
    changelog = "https://github.com/rmartin16/qbittorrent-api/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ savyajha ];
  };
})
