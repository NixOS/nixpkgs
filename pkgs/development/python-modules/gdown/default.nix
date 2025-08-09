{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  hatch-vcs,
  hatch-fancy-pypi-readme,
  filelock,
  requests,
  tqdm,
  setuptools,
  six,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "gdown";
  version = "5.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IUUWUGLYVSCjzZizVsntUixeeYTUCFNUCf1G+U3vx4c=";
  };

  build-system = [
    hatchling
    hatch-vcs
    hatch-fancy-pypi-readme
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    filelock
    requests
    tqdm
    setuptools
    six
  ]
  ++ requests.optional-dependencies.socks;

  checkPhase = ''
    $out/bin/gdown --help > /dev/null
  '';

  pythonImportsCheck = [ "gdown" ];

  meta = with lib; {
    description = "CLI tool for downloading large files from Google Drive";
    mainProgram = "gdown";
    homepage = "https://github.com/wkentaro/gdown";
    changelog = "https://github.com/wkentaro/gdown/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ breakds ];
  };
}
