{
  lib,
  fetchPypi,
  buildPythonPackage,
  krb5-c, # C krb5 library, not PyPI krb5
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pykerberos";
  version = "1.2.4";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-nXAevY/FlsmdMVXVukWBO9WQjSbvg7oK3SUO22IqvtQ=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ krb5-c ]; # for krb5-config

  buildInputs = [ krb5-c ];

  # there are no tests
  doCheck = false;

  pythonImportsCheck = [ "kerberos" ];

  meta = {
    description = "High-level interface to Kerberos";
    homepage = "https://github.com/02strich/pykerberos";
    license = lib.licenses.asl20;
  };
})
