{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  setuptools,
  requests,
}:

buildPythonPackage rec {
  pname = "nextcloudmonitor";
  version = "1.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meichthys";
    repo = "nextcloud_monitor";
    tag = "v${version}";
    hash = "sha256-9iohznUmDusNY7iJZBcv9yn2wp3X5cS8n3Fbj/G1u0g=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/meichthys/nextcloud_monitor/pull/10
      url = "https://github.com/meichthys/nextcloud_monitor/commit/cf6191d148e0494de5ae3cbe8fc5ffdba71b6c21.patch";
      hash = "sha256-BSTX5dw+k+ItT6qvpjLiDsH9rW1NmkaBeGO9TlNZZis=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "nextcloudmonitor" ];

  meta = with lib; {
    changelog = "https://github.com/meichthys/nextcloud_monitor/blob/${src.tag}/README.md#change-log";
    description = "Python wrapper around nextcloud monitor api";
    homepage = "https://github.com/meichthys/nextcloud_monitor";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
