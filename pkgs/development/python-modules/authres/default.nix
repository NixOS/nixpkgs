{
  lib,
  fetchPypi,
  buildPythonPackage,
  python,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "authres";
  version = "1.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-k9G5la184h5i22SfNhBIEl3WAiVjoK6KI5CUZfH9Jbc=";
  };

  build-system = [ setuptools ];

  checkPhase = ''
    # run doctests
    ${python.interpreter} -m authres
  '';

  meta = {
    description = "Email Authentication-Results Headers generation and parsing for Python/Python3";
    longDescription = ''
      Python module that implements various internet RFC's: 5451/7001/7601
      Authentication-Results Headers generation and parsing for
      Python/Python3.
    '';
    homepage = "https://launchpad.net/authentication-results-python";
    changelog = "https://git.launchpad.net/authentication-results-python/tree/CHANGES";
    license = lib.licenses.bsd3;
    hasNoMaintainersButDependents = true;
  };
})
