{
  lib,
  buildPythonPackage,
  fetchPypi,
  findutils,
  krb5-c,
  setuptools,
  replaceVars,
}:

buildPythonPackage rec {
  pname = "k5test";
  version = "0.10.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4VJJHmYC9qk7PVM9OHvUWQ8kdgk7aEIXD/C5PeZL7zA=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      inherit findutils;
      krb5 = krb5-c;
      # krb5-config is in dev output
      krb5Dev = krb5-c.dev;
    })
  ];

  nativeBuildInputs = [ setuptools ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "k5test" ];

  meta = {
    description = "Library for setting up self-contained Kerberos 5 environment";
    homepage = "https://github.com/pythongssapi/k5test";
    changelog = "https://github.com/pythongssapi/k5test/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
