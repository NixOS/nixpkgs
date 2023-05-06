{
  lib,
  fetchPypi,
  buildPythonPackage,
  abstract-singleton,
  hatchling,
}:

buildPythonPackage rec {
  pname = "auto-gpt-plugin-template";
  version = "0.0.3";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "auto_gpt_plugin_template";
    hash = "sha256-P1ERD3jbSQqJpRQvzfRBdu8IgSWkGPUHsQDoE+pa/QY=";
  };

  nativeBuildInputs = [
    abstract-singleton
  ];

  propagatedBuildInputs = [
    hatchling
  ];

  meta = {
    changelog = "https://github.com/Significant-Gravitas/Auto-GPT-Plugin-Template/releases/tag/${version}";
    homepage = "https://github.com/Significant-Gravitas/Auto-GPT-Plugin-Template";
    description = "A starting point for developing your own plug-in for Auto-GPT";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.drupol ];
  };
}
