{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "rtfunicode";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "mjpieters";
    repo = "rtfunicode";
    tag = version;
    hash = "sha256-5lmiazxiEENpdqzVgoKQoG2OW/w5nGmC8odulo2XaLo=";
  };

  nativeBuildInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "rtfunicode" ];

  meta = {
    description = "Encoder for unicode to RTF 1.5 command sequences";
    maintainers = [ lib.maintainers.lucasew ];
    license = lib.licenses.bsd2;
    homepage = "https://github.com/mjpieters/rtfunicode";
    changelog = "https://github.com/mjpieters/rtfunicode/releases/tag/${version}";
  };
}
