{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "cobs";
  version = "1.2.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-291eMhEdcnhvg9DCaSFdzWrGKbGsGWLGh4Ih87LKmNo=";
  };

  checkPhase = ''
    runHook preCheck

    python -m cobs.cobs.test
    python -m cobs.cobsr.test

    runHook postCheck
  '';

  pythonImportsCheck = [
    "cobs"
    "cobs.cobs"
    "cobs.cobsr"
  ];

  meta = {
    description = "Python functions for encoding and decoding COBS";
    longDescription = ''
      COBS is a method of encoding a packet of bytes into a form that contains no bytes with value zero (0x00). The input packet of bytes can contain bytes in the full range of 0x00 to 0xFF. The COBS encoded packet is guaranteed to generate packets with bytes only in the range 0x01 to 0xFF. Thus, in a communication protocol, packet boundaries can be reliably delimited with 0x00 bytes.
    '';
    homepage = "https://github.com/cmcqueen/cobs-python/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kip93 ];
  };
}
