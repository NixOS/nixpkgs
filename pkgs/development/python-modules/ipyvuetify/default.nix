{
  lib,
  buildPythonPackage,
  fetchPypi,
  # Python Inputs
  jupyter-packaging,
  jupyterlab,
  setuptools,
  wheel,
  ipyvue,
}:

buildPythonPackage rec {
  pname = "ipyvuetify";
  version = "1.9.4";
  pyproject = true;

  # GitHub version tries to run npm (Node JS)
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wpwfN68wpj2+lLb4w0erAZYa7OrbVhNfGMv0635oiVs=";
  };

  # drop pynpm which tries to install node_modules
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "jupyter_packaging~=0.7.9" "jupyter_packaging" \
      --replace-fail "jupyterlab~=3.0" "jupyterlab" \
      --replace-fail '"pynpm"' ""

    substituteInPlace setup.py \
      --replace-fail "from pynpm import NPMPackage" "" \
      --replace-fail "from generate_source import generate_source" "" \
      --replace-fail 'setup(cmdclass={"egg_info": js_prerelease(egg_info)})' 'setup()'
  '';

  nativeBuildInputs = [
    jupyter-packaging
    jupyterlab
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ ipyvue ];

  doCheck = false; # no tests on PyPi/GitHub
  pythonImportsCheck = [ "ipyvuetify" ];

  meta = with lib; {
    description = "Jupyter widgets based on Vuetify UI Components";
    homepage = "https://github.com/mariobuikhuizen/ipyvuetify";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
