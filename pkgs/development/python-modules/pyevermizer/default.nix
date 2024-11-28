{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  nix-update-script,
}:
buildPythonPackage rec {
  pname = "pyevermizer";
  version = "0.48.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9TNqiWzc/0sUN+FC9t9j/LYRyJFptdn/VBek5n3QZVs=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "pyevermizer" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python wrapper for Secret of Evermore Randomizer";
    homepage = "https://github.com/black-sliver/pyevermizer";
    license = with lib.licenses; [
      gpl3Only
      lgpl3Only
    ];
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
