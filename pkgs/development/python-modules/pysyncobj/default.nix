{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysyncobj";
  version = "0.3.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bakwc";
    repo = "PySyncObj";
    tag = "v${finalAttrs.version}";
    hash = "sha256-p4Jmyf/Y/pyHFn0lAACqaZCqXWdmmDMJwgyM5DDNJd4=";
  };

  build-system = [ setuptools ];

  # Tests require network features
  doCheck = false;

  pythonImportsCheck = [ "pysyncobj" ];

  meta = {
    description = "Python library for replicating your class";
    homepage = "https://github.com/bakwc/PySyncObj";
    changelog = "https://github.com/bakwc/PySyncObj/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "syncobj_admin";
  };
})
