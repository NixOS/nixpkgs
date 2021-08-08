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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qygv9lkd1jad5b4l0zz6hsi7m8q0fmpwaa6hpp7p9x6ql7gnyl8";
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
      --replace "prometheus_client==0.9.0" "prometheus-client"
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
