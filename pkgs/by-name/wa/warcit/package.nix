{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication {
  pname = "warcit";
  version = "0.4.0-unstable-2024-11-28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "webrecorder";
    repo = "warcit";
    rev = "3cba1ad2c3e9bddd33c3babf45c2a03b5d8935ef";
    hash = "sha256-hqQPQWmhR6/NP3XsQkjlOIVbbDfoOf9uhhvlJvIPNZE=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    warcio
    faust-cchardet
    pyyaml
  ];

  pythonImportsCheck = [
    "warcit"
  ];

  meta = {
    description = "Convert Directories, Files and ZIP Files to Web Archives (WARC)";
    homepage = "https://github.com/webrecorder/warcit";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ zhaofengli ];
    mainProgram = "warcit";
  };
}
