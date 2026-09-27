{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytest,
  zlib,
  xz,
}:

buildPythonPackage (finalAttrs: {
  pname = "deeptoolsintervals";
  version = "0.1.9";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-fZTDb9K28Q2LmeU20mcugiiXHx/IEEl9M1J7uixA1PY=";
  };

  build-system = [ setuptools ];

  buildInputs = [
    zlib
    xz
  ];

  nativeCheckInputs = [ pytest ];

  pythonImportsCheck = [ "deeptoolsintervals" ];

  meta = {
    homepage = "https://deeptools.readthedocs.io/en/develop";
    description = "Helper library for deeptools";
    license = lib.licenses.mit;
  };
})
