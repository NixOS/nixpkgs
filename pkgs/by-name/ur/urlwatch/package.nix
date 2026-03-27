{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "urlwatch";
  version = "2.29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thp";
    repo = "urlwatch";
    tag = finalAttrs.version;
    hash = "sha256-X1UR9JrQuujOIUg87W0YqfXsM3A5nttWjjJMIe3hgk8=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    aioxmpp
    beautifulsoup4
    cssbeautifier
    cssselect
    jq
    jsbeautifier
    keyring
    lxml
    markdown2
    matrix-client
    minidb
    platformdirs
    playwright
    pushbullet-py
    pycodestyle
    pyyaml
    requests
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "urlwatch" ];

  meta = {
    description = "Tool for monitoring webpages for updates";
    homepage = "https://thp.io/2008/urlwatch/";
    changelog = "https://github.com/thp/urlwatch/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      kmein
      tv
    ];
    mainProgram = "urlwatch";
  };
})
