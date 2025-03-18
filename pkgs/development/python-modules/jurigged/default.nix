{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  fetchPypi,
  blessed,
  codefind,
  giving,
  hatchling,
  ovld,
  pygments,
  rich,
  watchdog,
}:

buildPythonPackage rec {
  pname = "jurigged";
  version = "0.6.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MB045JdHSr0nwpBuP3ThrSaDZ3HRMQjGzNjANZizXTo=";
  };

  build-system = [ hatchling ];

  dependencies = [
    blessed
    codefind
    giving
    ovld
    pygments
    rich
    watchdog
  ];

  pythonImportsCheck = [ "jurigged" ];

  meta = {
    description = "Hot reloading for Python";
    homepage = "https://github.com/breuleux/jurigged";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
