{
  buildPythonPackage,
  fetchPypi,
  lib,
  nix-update-script,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "inflate64";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MniCe4A88Aah3yUfPhM3TH0m23eeWjMynMEXibgEvC0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://codeberg.org/miurahr/inflate64/";
    description = "Implementation of the Enhanced Deflate compression algorithm";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.jwillikers ];
  };
}
