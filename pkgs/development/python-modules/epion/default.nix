{
  lib,
  buildPythonPackage,
  docopt,
  fetchFromGitHub,
  pytz,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "epion";
  version = "0.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "devenzo-com";
    repo = "epion_python";
    tag = finalAttrs.version;
    hash = "sha256-9tE/SqR+GHZXeE+bOtXkLu+4jy1vO8WoiLjb6MJazxQ=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    docopt
    pytz
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "epion" ];

  meta = {
    description = "Module to access Epion sensor data";
    homepage = "https://github.com/devenzo-com/epion_python";
    changelog = "https://github.com/devenzo-com/epion_python/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
