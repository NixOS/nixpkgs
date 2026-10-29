{
  lib,
  buildPythonPackage,
  fetchPypi,
  psutil,
  unittestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyperf";
  version = "2.10.0";
  pyproject = true;

  src = fetchPypi {
    pname = "pyperf";
    inherit (finalAttrs) version;
    hash = "sha256-3ZPM/aeSFHJSk+lfH6bgDLSmStzxMmA5SG1OH5HKqmI=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ psutil ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlags = [
    "--start-directory=pyperf/tests"
    "-v"
  ];

  pythonImportsCheck = [ "pyperf" ];

  meta = {
    description = "Python module to generate and modify perf";
    mainProgram = "pyperf";
    homepage = "https://pyperf.readthedocs.io/";
    changelog = "https://github.com/psf/pyperf/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
