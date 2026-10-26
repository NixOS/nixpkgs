{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  bundlewrap,
  pass,
}:

buildPythonPackage (finalAttrs: {
  pname = "bundlewrap-pass";
  version = "1.0.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-3KmUTTOQ46TiKXNkKLRweMEe5m/zJ1gvAVJttJBdzik=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    bundlewrap
    pass
  ];

  # upstream has no checks
  doCheck = false;

  pythonImportsCheck = [ "bwpass" ];

  meta = {
    homepage = "https://pypi.org/project/bundlewrap-pass";
    description = "Use secrets from pass in your BundleWrap repo";
    license = lib.licenses.gpl3;
    maintainers = [ ];
  };
})
