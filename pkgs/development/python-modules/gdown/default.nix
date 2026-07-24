{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchPypi,
  filelock,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,
  requests,
  setuptools,
  tqdm,
}:

buildPythonPackage (finalAttrs: {
  pname = "gdown";
  version = "5.2.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-pLr7qmJ9Z72qaNJ06elXEnuoELS89FBeK1fqRaoKoeY=";
  };

  build-system = [
    hatchling
    hatch-vcs
    hatch-fancy-pypi-readme
  ];

  dependencies = [
    beautifulsoup4
    filelock
    requests
    setuptools
    tqdm
  ]
  ++ requests.optional-dependencies.socks;

  checkPhase = ''
    $out/bin/gdown --help > /dev/null
  '';

  pythonImportsCheck = [ "gdown" ];

  meta = {
    description = "CLI tool for downloading large files from Google Drive";
    homepage = "https://github.com/wkentaro/gdown";
    changelog = "https://github.com/wkentaro/gdown/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ breakds ];
    mainProgram = "gdown";
  };
})
