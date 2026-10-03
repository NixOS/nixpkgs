{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "mscerts";
  version = "2026.8.28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ralphje";
    repo = "mscerts";
    tag = finalAttrs.version;
    hash = "sha256-1ibwzs44ps0bTylG+32W1+3hx121oGpdsZnv8OV6bZs=";
  };

  build-system = [ setuptools ];

  # extras_require contains signify -> circular dependency

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "mscerts" ];

  meta = {
    description = "Makes the Microsoft Trusted Root Program's Certificate Trust Lists available in Python";
    homepage = "https://github.com/ralphje/mscerts";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
