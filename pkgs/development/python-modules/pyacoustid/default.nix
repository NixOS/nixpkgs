{
  lib,
  audioread,
  buildPythonPackage,
  fetchFromGitHub,
  pkgs,
  poetry-core,
  pytestCheckHook,
  requests,
  stdenv,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyacoustid";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beetbox";
    repo = "pyacoustid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7bL1g7Zvzc+Re0zSjsEqFsNzgkgwh+onoS4sQk0t55o=";
  };

  postPatch = ''
    substituteInPlace chromaprint.py \
      --replace "ctypes.CDLL(name" 'ctypes.CDLL("${lib.getLib pkgs.chromaprint}/lib/libchromaprint${stdenv.hostPlatform.extensions.sharedLibrary}"'
  '';

  build-system = [
    poetry-core
  ];

  dependencies = [
    audioread
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "acoustid" ];

  meta = {
    description = "Bindings for Chromaprint acoustic fingerprinting and the Acoustid Web service";
    homepage = "https://github.com/beetbox/pyacoustid";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
