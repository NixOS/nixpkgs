{
  lib,
  asn1tools,
  bidict,
  buildPythonPackage,
  cmd2_3,
  colorlog,
  construct,
  cryptography,
  fetchFromGitHub,
  gsm0338,
  jsonpath-ng,
  packaging,
  pycryptodomex,
  pyosmocom,
  pyscard,
  pyshark,
  pyserial,
  pytestCheckHook,
  pytlv,
  pyyaml,
  setuptools,
  smpp-pdu,
  smpp-twisted3,
  smpplib,
  termcolor,
}:

buildPythonPackage {
  pname = "pysim";
  version = "1.0-unstable-2026-10-09";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "pysim";
    rev = "9aa8934da2415b161eb9726adad2ba7b4f35d1a7";
    hash = "sha256-0bqryqhL0CEETVGJ/xgp9EgTV2or8jrN1Y+jFWBQE20";
  };

  postPatch = ''
    substituteInPlace setup.py --replace-fail 'smpp.pdu @ git+https://github.com/hologram-io/smpp.pdu' 'smpp.pdu'
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    asn1tools
    bidict
    cmd2_3
    colorlog
    construct
    cryptography
    gsm0338
    jsonpath-ng
    packaging
    pycryptodomex
    pyosmocom
    pyscard
    pyshark
    pyserial
    pytlv
    pyyaml
    smpp-pdu
    smpp-twisted3
    smpplib
    termcolor
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "pySim"
    "pySim.commands"
    "pySim.filesystem"
    "pySim.transport"
    "pySim.utils"
  ];

  meta = {
    description = "Python tool to program SIMs / USIMs / ISIMs";
    homepage = "https://github.com/osmocom/pysim";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ jeyemwey ];
  };
}
