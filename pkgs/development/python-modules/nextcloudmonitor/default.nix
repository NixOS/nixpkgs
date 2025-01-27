{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
}:

buildPythonPackage rec {
  pname = "nextcloudmonitor";
  version = "1.5.2";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "meichthys";
    repo = "nextcloud_monitor";
    tag = "v${version}";
    hash = "sha256-9iohznUmDusNY7iJZBcv9yn2wp3X5cS8n3Fbj/G1u0g=";
  };

  propagatedBuildInputs = [ requests ];

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
