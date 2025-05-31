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
  version = "2.9.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "jxmorris12";
    repo = "language_tool_python";
    tag = version;
    hash = "sha256-CiKwuCMfgU7Vo0rwbKyI++EJBuKBrN1q7alwYGKuXXQ=";
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
