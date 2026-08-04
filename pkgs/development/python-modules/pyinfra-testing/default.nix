{
  lib,
  buildPythonPackage,
  fetchPypi,
  uv-build,
  freezegun,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "pyinfra-testing";
  version = "0.2.1";
  pyproject = true;

  src = fetchPypi {
    pname = "pyinfra_testing";
    inherit version;
    hash = "sha256-I5rR+Ew4pFYExoWmXSY/kqUDyiuEJ8jTASS4L8Gklx0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.8.14,<0.9.0" uv_build
  '';

  build-system = [ uv-build ];

  dependencies = [
    freezegun
    pyyaml
  ];

  pythonImportsCheck = [ "pyinfra_testing" ];

  # upstream ships no tests in the sdist; its test suite would also need pyinfra itself
  doCheck = false;

  meta = {
    description = "Generate unittest tests for pyinfra facts and operations from data files";
    homepage = "https://github.com/pyinfra-dev/pyinfra-testing";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.robsliwi ];
  };
}
