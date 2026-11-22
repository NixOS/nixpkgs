{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lightify";
  version = "1.0.7.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tfriedel";
    repo = "python-lightify";
    tag = "v${version}";
    hash = "sha256-zgDB1Tq4RYIeABZCjCcoB8NGt+ZhQFnFu655OghgpH0=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "lightify" ];

  # tests access the network
  doCheck = false;

  meta = {
    changelog = "https://github.com/tfriedel/python-lightify/releases/tag/${src.tag}";
    description = "Library to work with OSRAM Lightify";
    homepage = "https://github.com/tfriedel/python-lightify";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
