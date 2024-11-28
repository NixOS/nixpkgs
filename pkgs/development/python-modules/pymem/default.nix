{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  setuptools,
  regex,
  nix-update-script,
}:
buildPythonPackage rec {
  pname = "pymem";
  version = "1.13.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "Pymem";
    hash = "sha256-grUAQOLoUXnccC2T1IV7R14NLrRJvV8cUNP0DrBa4a0=";
  };

  build-system = [
    poetry-core
    setuptools
  ];

  dependencies = [ regex ];

  pythonImportsCheck = [ "pymem" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python library to manipulate Windows processes";
    homepage = "https://github.com/srounet/Pymem";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
    # While this is a windows-only library, it being on linux systems is harmless and sometimes required.
    platforms = lib.platforms.windows ++ lib.platforms.linux;
  };
}
