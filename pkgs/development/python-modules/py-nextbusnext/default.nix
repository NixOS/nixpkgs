{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-nextbusnext";
  version = "2.2.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "ViViDboarder";
    repo = "py_nextbus";
    tag = "v${version}";
    hash = "sha256-UA5/OjmgWU9vd9NGjH2qUUELsOpFayEVaO7hB91yQ74=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  pythonImportsCheck = [ "py_nextbus" ];

  # upstream has no tests
  doCheck = false;

  meta = with lib; {
    description = "Minimalistic Python client for the NextBus public API";
    homepage = "https://github.com/ViViDboarder/py_nextbus";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
