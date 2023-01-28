{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
}:

buildPythonPackage rec {
  pname = "nextcloudmonitor";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "meichthys";
    repo = "nextcloud_monitor";
    rev = "v${version}";
    sha256 = "0b0c7gzx1d5kgbsfj1lbrqsirc5g5br6v8w2njaj1ys03kj669cx";
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
