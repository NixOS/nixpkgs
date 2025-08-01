{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "rtfunicode";
  version = "1.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mjpieters";
    repo = "rtfunicode";
    tag = version;
    hash = "sha256-5lmiazxiEENpdqzVgoKQoG2OW/w5nGmC8odulo2XaLo=";
  };

  nativeBuildInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "rtfunicode" ];

  meta = with lib; {
    description = "Encoder for unicode to RTF 1.5 command sequences";
    maintainers = [ maintainers.lucasew ];
    license = licenses.bsd2;
    homepage = "https://github.com/mjpieters/rtfunicode";
    changelog = "https://github.com/mjpieters/rtfunicode/releases/tag/${version}";
  };
}
