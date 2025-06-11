{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  colorlog,
  smpp-pdu,
  pyscard,
  packaging,
  gsm0338,
  bidict,
  jsonpath-ng,
  termcolor,
  pyyaml,
  pycryptodomex,
  construct,
  pyserial,
  pytlv,
  cmd2,
}:

buildPythonPackage {
  pname = "pysim";
  version = "unstable-2023-08-13";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "pysim";
    rev = "09ff0e2b433b7143d5b40b4494744569b805e554";
    hash = "sha256-7IwIovGR0GcS1bidSqoytmombK6NkLSVAfKB2teW2JU=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace 'smpp.pdu @ git+https://github.com/hologram-io/smpp.pdu' 'smpp.pdu'
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    bidict
    cmd2
    colorlog
    construct
    gsm0338
    jsonpath-ng
    packaging
    pycryptodomex
    pyscard
    pyserial
    pytlv
    pyyaml
    smpp-pdu
    termcolor
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pySim" ];

  meta = with lib; {
    description = "Python tool to program SIMs / USIMs / ISIMs";
    homepage = "https://github.com/osmocom/pysim";
    license = licenses.gpl2;
    maintainers = with maintainers; [ flokli ];
  };
}
