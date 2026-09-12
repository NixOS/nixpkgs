{
  fetchFromGitHub,
  buildPythonPackage,
  lib,
  setuptools,
  requests,
  tqdm,
  psutil,
  toml,
  pip,
}:
buildPythonPackage rec {
  pname = "language-tool-python";
  version = "LanguageTool-6.8";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "jxmorris12";
    repo = "language_tool_python";
    tag = version;
    hash = "sha256-X6tp3f2DgsKv78BVL0cQrhZyew+YRfYiXLqQE+cCMtg=";
  };

  build-system = [ setuptools ];
  dependencies = [
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
    changelog = "https://github.com/jxmorris12/language_tool_python/releases/tag/${src.tag}";
  };
}
