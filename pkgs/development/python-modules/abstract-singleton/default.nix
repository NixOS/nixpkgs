{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "abstract-singleton";
  version = "1.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit version;
    pname = "abstract_singleton";
    hash = "sha256-2X0m7Ly3Qi943xsLykigPfW6BM9YhExtoDOnhAvqroI=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  pythonImportsCheck = [
    "abstract_singleton"
  ];

  meta = {
    changelog = "https://github.com/BillSchumacher/Abstract-Singleton/releases/tag/${version}";
    homepage = "https://github.com/BillSchumacher/Abstract-Singleton";
    description = "A Singleton that also enforces abstract methods are implemented";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.drupol ];
  };
}
