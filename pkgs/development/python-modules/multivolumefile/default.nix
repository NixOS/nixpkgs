{
  buildPythonPackage,
  coverage,
  fetchPypi,
  hypothesis,
  lib,
  nix-update-script,
  pyannotate,
  pytestCheckHook,
  pytest-cov,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "multivolumefile";
  version = "0.2.3";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oGSNCq+8luWRmNXBfprK1+tTGr6lEDXQjOgGDcrXCdY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    coverage
    hypothesis
    pyannotate
    pytest-cov
    pytestCheckHook
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://codeberg.org/miurahr/multivolume";
    description = "Library to provide a file-object wrapping multiple files as a virtual single file";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.jwillikers ];
  };
}
