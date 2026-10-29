{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "lightify";
  version = "1.0.7.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tfriedel";
    repo = "python-lightify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zgDB1Tq4RYIeABZCjCcoB8NGt+ZhQFnFu655OghgpH0=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "lightify" ];

  # tests access the network
  doCheck = false;

  meta = {
    changelog = "https://github.com/tfriedel/python-lightify/releases/tag/${finalAttrs.src.tag}";
    description = "Library to work with OSRAM Lightify";
    homepage = "https://github.com/tfriedel/python-lightify";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
