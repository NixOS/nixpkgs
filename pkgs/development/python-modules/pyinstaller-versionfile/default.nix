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
  version = "2.1.1";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "DudeNr33";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-lz1GuiXU+r8sMld5SsG3qS+FOsWfbvkQmO2bxAR3XcY=";
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
