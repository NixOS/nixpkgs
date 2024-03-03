{ lib
, buildPythonPackage
, fetchPypi
, requests
, urllib3
, packaging
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "qbittorrent-api";
  version = "2024.1.58";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6JyU9mr0xfRLB7AJOcnPc+PpF0EWi/R/Wy3lCKanAmA=";
  };

  propagatedBuildInputs = [
    requests
    urllib3
    packaging
  ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  # Tests require internet access
  doCheck = false;

  pythonImportsCheck = [
    "qbittorrentapi"
  ];

  meta = with lib; {
    description = "Python client implementation for qBittorrent's Web API";
    homepage = "https://github.com/rmartin16/qbittorrent-api";
    changelog = "https://github.com/rmartin16/qbittorrent-api/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ savyajha ];
  };
}
