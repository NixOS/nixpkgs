{ buildPythonPackage
, click
, fetchPypi
, gitpython
, lib
, nix-update-script
, requests
, setuptools-scm
, setuptools
}:

buildPythonPackage rec {
  pname = "oca-port";
  version = "0.12";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "oca_port";
    hash = "sha256-adwqnhe5BLo5tsjaLb0XHlTFxSKNutsb6hlTXjA4Wio=";
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

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  passthru.updateScript = nix-update-script { };

  pythonImportsCheck = [ "oca_port" ];

  meta = with lib; {
    description = "Tool helping to port an addon or missing commits of an addon from one branch to another";
    homepage = "https://github.com/OCA/oca-port";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ yajo ];
  };
}
