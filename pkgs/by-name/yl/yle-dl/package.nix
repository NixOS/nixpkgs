{
  lib,
  python3Packages,
  fetchFromGitHub,
  ffmpeg,
  wget,
  versionCheckHook,
}:

let
  version = "20260624";

  src = fetchFromGitHub {
    owner = "aajanki";
    repo = "yle-dl";
    tag = "releases/${version}";
    hash = "sha256-7wI7GKMdj28ef6M8eqkeuLytliU0D3arE0IXk5uhVfg=";
  };
in
python3Packages.buildPythonApplication {
  pname = "yle-dl";
  inherit version src;
  pyproject = true;

  build-system = with python3Packages; [ flit-core ];

  dependencies = with python3Packages; [
    configargparse
    lxml
    requests
  ];

  pythonPath = [
    wget
    ffmpeg
  ];

  nativeCheckInputs = [
    versionCheckHook
    # tests require network access
    # python3Packages.pytestCheckHook
  ];

  meta = {
    description = "Downloads videos from Yle (Finnish Broadcasting Company) servers";
    homepage = "https://aajanki.github.io/yle-dl/";
    changelog = "https://github.com/aajanki/yle-dl/blob/${src.tag}/ChangeLog";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "yle-dl";
  };
}
