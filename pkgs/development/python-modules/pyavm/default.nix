{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  hatchling,
  astropy,
  numpy,
  pillow,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyavm";
  version = "0.9.10";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-f2B+wtDOcyBNFO7lxUX0INT1t6w/WSenrdeBcvmQbcE=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [
    astropy
    numpy
    pillow
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyavm" ];

  meta = {
    description = "Simple pure-python AVM meta-data handling";
    homepage = "https://astrofrog.github.io/pyavm/";
    changelog = "https://github.com/astrofrog/pyavm/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ smaret ];
  };
})
