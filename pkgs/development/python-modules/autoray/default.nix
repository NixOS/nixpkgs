{
  lib,
  fetchPypi,
  buildPythonPackage,
  pythonOlder,
  hatchling,
  hatch-vcs,
}:

buildPythonPackage rec {
  pname = "autoray";
  version = "0.8.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit version;
    pname = "autoray";
    hash = "sha256-XQ1x2gPLAtW8WQoa9k4LpYWJNS1iiEOg7Lz+kAQNxSA=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  doCheck = true;

  pythonImportsCheck = [ "autoray" ];

  meta = {
    homepage = "https://github.com/jcmgray/autoray";
    description = "Abstract your array operations";
    maintainers = with lib.maintainers; [ anderscs ];
    license = lib.licenses.asl20;
  };
}
