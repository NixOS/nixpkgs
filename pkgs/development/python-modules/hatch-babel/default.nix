{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  babel,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "hatch-babel";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NiklasRosenstein";
    repo = "hatch-babel";
    tag = version;
    hash = "sha256-TQmF+aHlh5NmrE/v0Q6RV5SD106TlhAIiNvQfc61h9I=";
  };

  build-system = [ hatchling ];

  dependencies = [
    babel
    typing-extensions
  ];

  pythonImportsCheck = [ "hatch_babel" ];

  meta = {
    description = "Hatch build-hook to compile Babel *.po files to *.mo files at build time";
    homepage = "https://github.com/NiklasRosenstein/hatch-babel";
    changelog = "https://github.com/NiklasRosenstein/hatch-babel/blob/${src.tag}/.changelog/${src.tag}.toml";
    license = lib.licenses.unfree;
  };
}
