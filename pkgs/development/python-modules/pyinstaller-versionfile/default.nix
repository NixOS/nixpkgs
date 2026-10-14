{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  packaging,
  jinja2,
  pyyaml,
  poetry-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyinstaller-versionfile";
  version = "3.1.0";

  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DudeNr33";
    repo = "pyinstaller-versionfile";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L94MrZjCOw2Cxj0kF+F35TixVNJUi1sK99FG9+CzaIg=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    packaging
    jinja2
    pyyaml
  ];

  meta = {
    description = "Create a windows version-file from a simple YAML file that can be used by PyInstaller";
    mainProgram = "create-version-file";
    changelog = "https://github.com/DudeNr33/pyinstaller-versionfile/blob/v${finalAttrs.version}/CHANGELOG.md";
    homepage = "https://pypi.org/project/pyinstaller-versionfile/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
