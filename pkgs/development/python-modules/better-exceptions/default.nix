{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "better-exceptions";
  version = "0.3.3";
  pyproject = true;

  src = fetchPypi {
    pname = "better_exceptions";
    inherit version;
    hash = "sha256-5Oa8GERNXwTm6JSxA4Hl6SHT1UQkBBgWLH21fp6zRTs=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "better_exceptions" ];

  # As noted by @WolfangAukang, some check files need to be disabled because of various errors, same with some tests.
  # After disabling and running the build, no tests are collected.
  doCheck = false;

  meta = {
    description = "Pretty and more helpful exceptions in Python, automatically";
    homepage = "https://github.com/qix-/better-exceptions";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.alex-nt ];
  };
}
