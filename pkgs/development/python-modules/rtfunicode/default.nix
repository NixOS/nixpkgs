{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "rtfunicode";
  version = "2.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mjpieters";
    repo = "rtfunicode";
    tag = "v${version}";
    hash = "sha256-dmPpMplCQIJMHhNFzOIjKwEHVio2mjFEbDmq1Y9UJkA=";
  };

  nativeBuildInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "rtfunicode" ];

  meta = {
    description = "Encoder for unicode to RTF 1.5 command sequences";
    maintainers = [ lib.maintainers.lucasew ];
    license = lib.licenses.bsd2;
    homepage = "https://github.com/mjpieters/rtfunicode";
    changelog = "https://github.com/mjpieters/rtfunicode/releases/tag/${src.tag}";
  };
}
