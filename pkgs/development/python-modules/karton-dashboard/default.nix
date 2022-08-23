{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, karton-core
, mistune
, prometheus-client
, pythonOlder
}:

buildPythonPackage rec {
  pname = "karton-dashboard";
  version = "1.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-C1wtpHyuTlNS6Se1rR0RGUl3xht4aphAtddKlIsOAkI=";
  };

  propagatedBuildInputs = [
    flask
    karton-core
    mistune
    prometheus-client
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "Flask==1.1.1" "Flask" \
      --replace "prometheus_client==0.11.0" "prometheus_client"
  '';

  # Project has no tests. pythonImportsCheck requires MinIO configuration
  doCheck = false;

  meta = with lib; {
    description = "Web application that allows for Karton task and queue introspection";
    homepage = "https://github.com/CERT-Polska/karton-dashboard";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
    broken = versionAtLeast mistune.version "2";
  };
}
