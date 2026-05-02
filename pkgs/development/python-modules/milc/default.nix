{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  argcomplete,
  colorama,
  halo,
  platformdirs,
  spinners,
  types-colorama,
  typing-extensions,
  setuptools,
  pytestCheckHook,
  semver,
}:

buildPythonPackage rec {
  pname = "milc";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "clueboard";
    repo = "milc";
    tag = version;
    hash = "sha256-YEUs+4muDLZJav9wDGSxsRe1vrO4sxcBger4wA2yXgY=";
  };

  postPatch = ''
    # Needed for tests
    patchShebangs --build \
      example \
      custom_logger \
      questions \
      sparkline \
      hello \
      passwd_confirm \
      passwd_complexity \
      config_source
  '';

  dependencies = [
    argcomplete
    colorama
    halo
    platformdirs
    spinners
    types-colorama
    typing-extensions
  ];

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    semver
  ];

  pythonImportsCheck = [ "milc" ];

  meta = {
    description = "Opinionated Batteries-Included Python 3 CLI Framework";
    mainProgram = "milc-color";
    homepage = "https://milc.clueboard.co";
    license = lib.licenses.mit;
  };
}
