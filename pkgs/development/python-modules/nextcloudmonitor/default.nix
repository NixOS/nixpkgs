{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "nextcloudmonitor";
  version = "1.3.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "meichthys";
    repo = "nextcloud_monitor";
    rev = "v${version}";
    hash = "sha256-Ivo5dqKcvE1e+1crZNzKHydprtMXkZdzDl4MsZviLQQ=";
  };

  propagatedBuildInputs = [
    requests
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "nextcloudmonitor" ];

  meta = with lib; {
    description = "Python wrapper around nextcloud monitor api";
    homepage = "https://github.com/meichthys/nextcloud_monitor";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
