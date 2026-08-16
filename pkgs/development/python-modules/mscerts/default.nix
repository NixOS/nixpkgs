{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "mscerts";
  version = "2026.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ralphje";
    repo = "mscerts";
    tag = finalAttrs.version;
    hash = "sha256-fJ/+s0z3zIxHNfCxjDIuSlpQ6lBeT1xAVyveS0pjrR8=";
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
