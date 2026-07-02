{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  dnspython,
}:

buildPythonPackage (finalAttrs: {
  pname = "pynslookup";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wesinator";
    repo = "pynslookup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GdI5Jg/+HjdtbzpLa28z/ZUGPJL9vEbJ+Jd4HP4pQCY=";
  };

  build-system = [ setuptools ];

  dependencies = [ dnspython ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "nslookup" ];

  meta = {
    description = "Module to do DNS lookups";
    homepage = "https://github.com/wesinator/pynslookup";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
