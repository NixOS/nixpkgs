{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pkgs, # Only for pkgs.plantuml,
  setuptools,
  httplib2,
  mkdocs,
}:

buildPythonPackage rec {
  pname = "mkdocs-build-plantuml";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "christo-ph";
    repo = "mkdocs_build_plantuml";
    tag = version;
    hash = "sha256-KTtZXeMZwbrx1M6Keu9BzT3GmarsVx9kEmn63rwHatI=";
  };

  # There's only one substitution, no patch is needed.
  postPatch = ''
    substituteInPlace mkdocs_build_plantuml_plugin/plantuml.py \
      --replace-fail "shutil.which('plantuml') or 'plantuml'" "'${lib.getExe pkgs.plantuml}'"
  '';

  build-system = [ setuptools ];

  dependencies = [
    httplib2
    mkdocs
  ];

  pythonImportsCheck = [ "mkdocs_build_plantuml_plugin" ];

  # No tests available
  doCheck = false;

  meta = {
    description = "MkDocs plugin to help generate your plantuml images locally or remotely as files (NOT inline)";
    homepage = "https://github.com/christo-ph/mkdocs_build_plantuml";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
