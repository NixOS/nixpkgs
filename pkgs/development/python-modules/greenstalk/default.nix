{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "greenstalk";
  version = "2.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-6Jt2lN2rvWlWK/4RFA/awa/J/ty+Lt9kZOr3w1VTPvg=";
  };

  build-system = [ hatchling ];

  doCheck = false;

  dependencies = [
  ];

  meta = {
    description = "A Python client for the beanstalkd work queue";
    homepage = "https://github.com/justinmayhew/greenstalk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jbcrail ];
  };
})
