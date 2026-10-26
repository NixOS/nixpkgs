{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "psychrolib";
  version = "2.5.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "psychrometrics";
    repo = "psychrolib";
    tag = finalAttrs.version;
    hash = "sha256-OkjoYIakF7NXluNTaJnUHk5cI5t8GnpqrbqHYwnLOts=";
  };

  sourceRoot = "${finalAttrs.src.name}/src/python";

  nativeBuildInputs = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "psychrolib" ];

  meta = {
    description = "Library of psychrometric functions to calculate thermodynamic properties";
    homepage = "https://github.com/psychrometrics/psychrolib";
    changelog = "https://github.com/psychrometrics/psychrolib/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
