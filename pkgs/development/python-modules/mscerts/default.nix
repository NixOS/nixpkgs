{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "mscerts";
  version = "2026.4.30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ralphje";
    repo = "mscerts";
    tag = finalAttrs.version;
    hash = "sha256-S6YQt0PaY9OpFFrTcnHrak+8/x105Af7xLW5jln8GK0=";
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
