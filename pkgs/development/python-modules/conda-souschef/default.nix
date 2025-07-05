{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  ruamel-yaml,
  ruamel-yaml-jinja2,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "conda-souschef";
  version = "2.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marcelotrevisani";
    repo = "souschef";
    tag = "v${version}";
    hash = "sha256-CxlXwZH1BQq4rZ+jVExd2IZqtyexC9f8Xj4glSY8dkI=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];
  dependencies = [
    ruamel-yaml
    ruamel-yaml-jinja2
  ];

  pythonImportsCheck = [ "souschef" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Library to easily manipulate conda recipes";
    homepage = "https://github.com/marcelotrevisani/souschef";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
