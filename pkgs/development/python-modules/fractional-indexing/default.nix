{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fractional-indexing";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "httpie";
    repo = "fractional-indexing-python";
    tag = finalAttrs.version;
    hash = "sha256-1/4e+scZ4CMbqEA9NHDVzpRLFMxwa1T1/oClb9x4ri8=";
  };

  build-system = [
    poetry-core
  ];

  # coverage is erroneously listed under [tool.poetry.dependencies] upstream
  pythonRemoveDeps = [ "coverage" ];

  pythonImportsCheck = [
    "fractional_indexing"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlags = [
    "tests.py"
  ];

  meta = {
    description = "Python implementation of fractional indexing";
    homepage = "https://github.com/httpie/fractional-indexing-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phanirithvij ];
    # dependency for Karrot https://nlnet.nl/project/Karrot-UX/
    teams = with lib.teams; [ ngi ];
  };
})
