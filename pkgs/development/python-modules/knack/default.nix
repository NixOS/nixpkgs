{
  lib,
  buildPythonPackage,
  fetchPypi,
  argcomplete,
  colorama,
  jmespath,
  pygments,
  pyyaml,
  six,
  tabulate,
  mock,
  vcrpy,
  pytest,
}:

buildPythonPackage (finalAttrs: {
  pname = "knack";
  version = "0.14.0";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Ld0y/WND7Jtu0NpymyEjYtDmsSCMAWJjPJDLb5SgWHc=";
  };

  propagatedBuildInputs = [
    argcomplete
    colorama
    jmespath
    pygments
    pyyaml
    six
    tabulate
  ];

  nativeCheckInputs = [
    mock
    vcrpy
    pytest
  ];

  checkPhase = ''
    HOME=$TMPDIR pytest .
  '';

  pythonImportsCheck = [ "knack" ];

  meta = {
    homepage = "https://github.com/microsoft/knack";
    description = "Command-Line Interface framework";
    changelog = "https://github.com/microsoft/knack/blob/v${finalAttrs.version}/HISTORY.rst";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
