{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "arpy";
  version = "2.3.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "viraptor";
    repo = "arpy";
    tag = finalAttrs.version;
    hash = "sha256-jD1XJJhcpJymn0CwZ65U06xLKm1JjHffmx/umEO7a5s=";
  };

  build-system = [ setuptools ];

  checkInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "arpy" ];

  meta = {
    description = "Library for accessing the archive files and reading the contents";
    homepage = "https://github.com/viraptor/arpy";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ thornycrackers ];
  };
})
