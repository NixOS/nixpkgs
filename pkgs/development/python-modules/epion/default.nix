{
  lib,
  buildPythonPackage,
  docopt,
  fetchFromGitHub,
  pythonOlder,
  pytz,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "epion";
  version = "0.0.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "devenzo-com";
    repo = "epion_python";
    tag = version;
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

<<<<<<< HEAD
  meta = {
    description = "Module to access Epion sensor data";
    homepage = "https://github.com/devenzo-com/epion_python";
    changelog = "https://github.com/devenzo-com/epion_python/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Module to access Epion sensor data";
    homepage = "https://github.com/devenzo-com/epion_python";
    changelog = "https://github.com/devenzo-com/epion_python/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
