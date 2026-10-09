{
  lib,
  buildPythonPackage,
  fetchPypi,
  msgpack,
  numpy,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mmtf-python";
  version = "1.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-EqAv4bcTHworjORbRvHgzdKLmBj+RJlVTCaISYfqDDI=";
  };

  propagatedBuildInputs = [
    msgpack
    numpy
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlags = [
    "-s"
    "mmtf/tests"
    "-p"
    "*_tests.py"
  ];

  pythonImportsCheck = [ "mmtf" ];

  meta = {
    description = "Python implementation of the MMTF API, decoder and encoder";
    homepage = "https://github.com/rcsb/mmtf-python";
    changelog = "https://github.com/rcsb/mmtf-python/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
  };
})
