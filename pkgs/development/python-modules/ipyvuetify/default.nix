{
  lib,
  buildPythonPackage,
  fetchPypi,
  # Python Inputs
  setuptools,
  ipyvue,
}:

buildPythonPackage rec {
  pname = "ipyvuetify";
  version = "1.11.3";
  pyproject = true;

  # GitHub version tries to run npm (Node JS)
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NYCvp22a3UrgTMt/1X1KDPA6JhcFdC5xN97z67Zaxx0=";
  };

  # drop pynpm which tries to install node_modules
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"jupyterlab~=4.0",' "" \
      --replace-fail '"pynpm"' ""
  '';

  build-system = [ setuptools ];

  dependencies = [ ipyvue ];

  doCheck = false; # no tests on PyPi/GitHub
  pythonImportsCheck = [ "ipyvuetify" ];

  meta = with lib; {
    description = "Jupyter widgets based on Vuetify UI Components";
    homepage = "https://github.com/mariobuikhuizen/ipyvuetify";
    license = licenses.mit;
    maintainers = [ ];
  };
}
