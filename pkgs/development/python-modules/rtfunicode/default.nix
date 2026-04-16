{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  unittestCheckHook,
  uv-build,
}:

buildPythonPackage rec {
  pname = "rtfunicode";
  version = "2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mjpieters";
    repo = "rtfunicode";
    tag = "v${version}";
    hash = "sha256-dmPpMplCQIJMHhNFzOIjKwEHVio2mjFEbDmq1Y9UJkA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.26,<0.10.0" "uv_build"
  '';

  build-system = [ uv-build ];

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
