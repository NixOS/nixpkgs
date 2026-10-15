{
  lib,
  buildPythonPackage,
  fetchPypi,
  uv-build,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "pyinfra-testgen";
  version = "0.1.1";
  pyproject = true;

  # no tags on GitHub
  src = fetchPypi {
    pname = "pyinfra_testgen";
    inherit version;
    hash = "sha256-c5pZ0SfRXC50vJZfnnf0HQgImf7hi2oQ5/XKMVNzlpc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.8.14,<0.9.0" uv_build
  '';

  build-system = [ uv-build ];

  dependencies = [
    pyyaml
  ];

  pythonImportsCheck = [ "testgen" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "Generate Python unit tests from JSON and YAML files";
    homepage = "https://github.com/pyinfra-dev/testgen";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
