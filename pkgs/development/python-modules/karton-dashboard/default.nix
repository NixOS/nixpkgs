{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, flask
, karton-core
, mistune
, networkx
, prometheus-client
, pythonOlder
}:

buildPythonPackage rec {
  pname = "karton-dashboard";
  version = "1.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-XMyQ0mRF4y61hqlqdxC+He+697P1URfOXQUMnV0pT7o=";
  };

  patches = [
    (fetchpatch {
      name = "update-mistune.patch";
      url = "https://github.com/CERT-Polska/karton-dashboard/commit/d0a2a1ffd21e9066acca77434acaff7b20e460d0.patch";
      hash = "sha256-LOqeLWoCXmVTthruBiQUYR03yPOPHhgYF/fJMhhT6Wo=";
    })
  ];

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
    changelog = "https://github.com/CERT-Polska/karton-dashboard/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
