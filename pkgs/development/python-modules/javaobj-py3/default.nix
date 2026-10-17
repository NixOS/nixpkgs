{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "javaobj-py3";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tcalmant";
    repo = "python-javaobj";
    tag = finalAttrs.version;
    hash = "sha256-o5cKavDTwoEIIzL3sxjdE+Ai209cP/cOmMSJLop0960=";
  };

  build-system = [ setuptools ];

  dependencies = [ numpy ];

  # Tests assume network connectivity
  doCheck = false;

  pythonImportsCheck = [ "javaobj" ];

  meta = {
    description = "Module for serializing and de-serializing Java objects";
    homepage = "https://github.com/tcalmant/python-javaobj";
    changelog = "https://github.com/tcalmant/python-javaobj/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
})
