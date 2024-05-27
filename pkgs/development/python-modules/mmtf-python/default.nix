{
  lib,
  buildPythonPackage,
  fetchPypi,
  msgpack,
  numpy,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "mmtf-python";
  version = "1.1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EqAv4bcTHworjORbRvHgzdKLmBj+RJlVTCaISYfqDDI=";
  };

  propagatedBuildInputs = [
    msgpack
    numpy
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s mmtf/tests"
    "-p \"*_tests.py\""
  ];

  pythonImportsCheck = [ "mmtf" ];

  meta = {
    description = "The python implementation of the MMTF API, decoder and encoder";
    homepage = "https://github.com/rcsb/mmtf-python";
    changelog = "https://github.com/rcsb/mmtf-python/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
