{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pydanfossair";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JonasPed";
    repo = "pydanfoss-air";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZTairxQbvijNiSomDoeZtmL/Hn3ce1Z5TEOf+0C8cYg=";
  };

  build-system = [ setuptools ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pydanfossair" ];

  meta = with lib; {
    description = "Python interface for Danfoss Air HRV systems";
    homepage = "https://github.com/JonasPed/pydanfoss-air";
    changelog = "https://github.com/JonasPed/pydanfoss-air/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
