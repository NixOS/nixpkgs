{
  lib,
  buildPythonPackage,
  fetchhg,
  setuptools,
  setuptools-scm,
  ruamel-yaml,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "ruamel-yaml-jinja2";
  version = "0.2.7";
  pyproject = true;

  src = fetchhg {
    url = "http://hg.code.sf.net/p/ruamel-yaml-jinja2/code";
    #tag = version;
    rev = version;
    hash = "sha256-OxhgSIgzoh8k/NO9tCvqi8ONXLrBYSzPgZ9SEsIsT4k=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];
  dependencies = [ ruamel-yaml ];

  pythonImportsCheck = [ "ruamel.yaml" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Ruamel YAML plugin that supports Jinja2 templates";
    homepage = "https://sourceforge.net/projects/ruamel-yaml-jinja2/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
