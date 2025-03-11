{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rova";
  version = "0.4.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

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

  meta = with lib; {
    description = "Module to access for ROVA calendars";
    homepage = "https://github.com/GidoHakvoort/rova";
    changelog = "https://github.com/GidoHakvoort/rova/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
