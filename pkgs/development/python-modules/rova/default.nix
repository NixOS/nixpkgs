{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rova";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GidoHakvoort";
    repo = "rova";
    tag = "v${version}";
    hash = "sha256-y73Vf/E2xDy+2vnvZEllRUgsDfX33Q7AsL/UY2pR1sI=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ requests ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "rova" ];

  meta = {
    description = "Module to access for ROVA calendars";
    homepage = "https://github.com/GidoHakvoort/rova";
    changelog = "https://github.com/GidoHakvoort/rova/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
