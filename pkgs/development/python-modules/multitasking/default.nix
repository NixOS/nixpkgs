{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "multitasking";
  version = "0.0.12";
  format = "setuptools";

  # GitHub source releases aren't tagged
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-L7ovqO2MS4XiJ8XdfcQcfWWN47byR5JzFhdaVzSbhNE=";
  };

  doCheck = false; # No tests included
  pythonImportsCheck = [ "multitasking" ];

  meta = {
    description = "Non-blocking Python methods using decorators";
    homepage = "https://github.com/ranaroussi/multitasking";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drewrisinger ];
  };
}
