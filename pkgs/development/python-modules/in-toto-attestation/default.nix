{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,

  # dependencies
  protobuf,
}:

buildPythonPackage rec {
  pname = "in-toto-attestation";
  version = "0.9.3";
  pyproject = true;

  # Tags on GitHub do not match the Pypi versions
  src = fetchPypi {
    pname = "in_toto_attestation";
    inherit version;
    hash = "sha256-zAz5dBfZSVO5/ubp1BWhHFm01HzuTxN0b/6TWyjj6MQ=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    protobuf
  ];

  pythonImportsCheck = [ "in_toto_attestation" ];

  # No tests in the Pypi archive
  doCheck = false;

  meta = {
    description = "Python implementation of in-toto attestations";
    homepage = "https://github.com/in-toto/attestation/tree/main/python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
