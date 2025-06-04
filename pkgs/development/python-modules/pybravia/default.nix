{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pybravia";
  version = "0.3.4";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Drafteed";
    repo = "pybravia";
    tag = "v${version}";
    hash = "sha256-1LfYEVclRneU3eD52kvzjLYyGdzYSWVDQ5EADOviglw=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pybravia" ];

  meta = with lib; {
    description = "Library for remote control of Sony Bravia TVs 2013 and newer";
    homepage = "https://github.com/Drafteed/pybravia";
    changelog = "https://github.com/Drafteed/pybravia/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
