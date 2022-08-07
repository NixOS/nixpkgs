{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, karton-core
, mistune
, networkx
, prometheus-client
, pythonOlder
}:

buildPythonPackage rec {
  pname = "karton-dashboard";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-thjAgK5EgevkFdKooljrrejwJorT6Lea9QSF0cZhxmw=";
  };

  propagatedBuildInputs = [
    flask
    karton-core
    mistune
    networkx
    prometheus-client
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "Flask==2.0.3" "Flask" \
      --replace "networkx==2.6.3" "networkx" \
      --replace "prometheus_client==0.11.0" "prometheus_client"
  '';

  # Project has no tests. pythonImportsCheck requires MinIO configuration
  doCheck = false;

  meta = with lib; {
    description = "Web application that allows for Karton task and queue introspection";
    homepage = "https://github.com/CERT-Polska/karton-dashboard";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
