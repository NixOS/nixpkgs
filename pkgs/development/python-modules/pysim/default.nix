{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,

  setuptools,
  pytestCheckHook,

  asn1tools,
  bidict,
  cmd2,
  colorlog,
  construct,
  cryptography,
  gsm0338,
  jsonpath-ng,
  packaging,
  pycryptodomex,
  pyosmocom,
  pyscard,
  pyserial,
  pytlv,
  pyyaml,
  smpp-pdu,
  smpp-twisted3,
  termcolor,
}:

buildPythonPackage {
  pname = "pysim";
  version = "1.0-unstable-2025-09-04";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "pysim";
    rev = "92841f2cd5f65aec0dfa3ad7a7643605c54abf3a";
    hash = "sha256-gXnc8QsHsF5XQO14fOszBnFeo5Mh/w5TNpY6zBTZdrk=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace-fail 'smpp.pdu @ git+https://github.com/hologram-io/smpp.pdu' 'smpp.pdu'
  '';

  build-system = [ setuptools ];

  dependencies = [
    asn1tools
    bidict
    cmd2
    colorlog
    construct
    cryptography
    gsm0338
    jsonpath-ng
    packaging
    pycryptodomex
    pyosmocom
    pyscard
    pyserial
    pytlv
    pyyaml
    smpp-pdu
    smpp-twisted3
    termcolor
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pySim" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Python tool to program SIMs / USIMs / ISIMs";
    homepage = "https://github.com/osmocom/pysim";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ flokli ];
  };
}
