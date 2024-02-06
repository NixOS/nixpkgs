{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "nextcloudmonitor";
  version = "1.5.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "meichthys";
    repo = "nextcloud_monitor";
    rev = "refs/tags/v${version}";
    hash = "sha256-3RVGE1vMLtVkZ4+/GwnNs4onctSw1dz6bsV1CC/gnpM=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "nextcloudmonitor" ];

  meta = with lib; {
    changelog = "https://github.com/meichthys/nextcloud_monitor/blob/${src.rev}/README.md#change-log";
    description = "Python wrapper around nextcloud monitor api";
    homepage = "https://github.com/meichthys/nextcloud_monitor";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
