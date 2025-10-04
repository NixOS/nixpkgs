{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fastcore,
  packaging,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ghapi";
  version = "1.0.8";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fastai";
    repo = "ghapi";
    tag = version;
    hash = "sha256-ZfOo5Icusj8Fm5i/HWGjjXtNWEB1wgYNzqeLeWbBJ/4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    fastcore
    packaging
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "ghapi" ];

  meta = with lib; {
    description = "Python interface to GitHub's API";
    homepage = "https://github.com/fastai/ghapi";
    changelog = "https://github.com/fastai/ghapi/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
