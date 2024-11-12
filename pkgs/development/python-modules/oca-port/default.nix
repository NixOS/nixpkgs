{
  buildPythonPackage,
  click,
  fetchPypi,
  gitpython,
  lib,
  nix-update-script,
  requests,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "oca-port";
  version = "0.15";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "oca_port";
    hash = "sha256-DqoIzZj++XF2ZYECpLQX1RD97Y3I2uvs1OI7QyfB7dE=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    click
    gitpython
    requests
  ];

  passthru.updateScript = nix-update-script { };

  pythonImportsCheck = [ "oca_port" ];

  meta = with lib; {
    description = "Tool helping to port an addon or missing commits of an addon from one branch to another";
    homepage = "https://github.com/OCA/oca-port";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ yajo ];
  };
}
