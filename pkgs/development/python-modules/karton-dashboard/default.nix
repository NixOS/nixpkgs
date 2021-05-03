{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, karton-core
, mistune
, prometheus_client
}:

buildPythonPackage rec {
  pname = "karton-dashboard";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    sha256 = "101qmx6nmiim0vrz2ldk973ns498hnxla1xy7nys9kh9wijg4msk";
  };

  propagatedBuildInputs = [
    flask
    karton-core
    mistune
    prometheus_client
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "Flask==1.1.1" "Flask" \
      --replace "karton-core==4.1.0" "karton-core"
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
