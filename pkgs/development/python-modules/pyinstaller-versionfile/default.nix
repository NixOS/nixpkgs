{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  packaging,
  jinja2,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "pyinstaller-versionfile";
  version = "3.0.1";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "DudeNr33";
    repo = "pyinstaller-versionfile";
    tag = "v${version}";
    hash = "sha256-UNrXP5strO6LIkIM3etBo1+Vm+1lR5wF0VfKtZYRoYc=";
  };

  propagatedBuildInputs = [
    packaging
    jinja2
    pyyaml
  ];

  meta = {
    description = "Create a windows version-file from a simple YAML file that can be used by PyInstaller";
    mainProgram = "create-version-file";
    homepage = "https://pypi.org/project/pyinstaller-versionfile/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
