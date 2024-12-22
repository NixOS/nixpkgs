{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "urlwatch";
  version = "2.29";

  src = fetchFromGitHub {
    owner = "thp";
    repo = "urlwatch";
    rev = version;
    hash = "sha256-X1UR9JrQuujOIUg87W0YqfXsM3A5nttWjjJMIe3hgk8=";
  };

  propagatedBuildInputs = with python3Packages; [
    cssselect
    jq
    keyring
    lxml
    markdown2
    matrix-client
    minidb
    playwright
    platformdirs
    pushbullet-py
    pycodestyle
    pyyaml
    requests
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Tool for monitoring webpages for updates";
    mainProgram = "urlwatch";
    homepage = "https://thp.io/2008/urlwatch/";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      kmein
      tv
    ];
  };
}
