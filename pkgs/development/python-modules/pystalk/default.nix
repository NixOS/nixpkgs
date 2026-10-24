{
  lib,
  attrs,
  buildPythonPackage,
  fetchPypi,
  pyyaml,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pystalk";
  version = "0.9.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-s6mPn5+DI1b8l746+mEtZDzAHhqM3MaEhZAjJbfW/q8=";
  };

  build-system = [ setuptools ];

  doCheck = false; # no tests

  dependencies = [
    attrs
    pyyaml
  ];

  meta = {
    description = "Simple Python Beanstalkd client";
    homepage = "https://github.com/easypost/pystalk";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ jbcrail ];
  };
})
