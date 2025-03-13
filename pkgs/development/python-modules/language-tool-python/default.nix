{
  python3,
  fetchFromGitHub,
  buildPythonPackage,
  lib,
}:
buildPythonPackage rec {
  pname = "language-tool-python";
  version = "2.8.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "jxmorris12";
    repo = "language_tool_python";
    tag = "${version}";
    hash = "sha256-v82RCg2lE0/ETJTiMogrI09fZ28tq1jhzFhbC89kbTU=";
  };

  build-system = [ python3.pkgs.setuptools ];
  dependencies = with python3.pkgs; [
    requests
    tqdm
    psutil
    toml
    pip
  ];

  meta = {
    description = "Free python grammar checker";
    homepage = "https://github.com/jxmorris12/language_tool_python";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ justdeeevin ];
    platforms = lib.platforms.all;
    changelog = "https://github.com/jxmorris12/language_tool_python/releases/tag/${version}";
  };
}
