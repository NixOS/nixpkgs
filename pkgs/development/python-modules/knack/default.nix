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

buildPythonPackage rec {
  pname = "knack";
  version = "0.13.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3aNbT/TFdrJQGhjw7C8v4KOl+czoJl1AZtMR5e1LW8Y=";
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
    changelog = "https://github.com/microsoft/knack/blob/v${version}/HISTORY.rst";
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
