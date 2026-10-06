{
  lib,
  aiofiles,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  protobuf,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "androidtvremote2";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tronikos";
    repo = "androidtvremote2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zyM9s8gtL0lBGd2hkANZRNsG7BEZv+c7Agexpk80OT0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    cryptography
    protobuf
  ];

  pythonImportsCheck = [ "androidtvremote2" ];

  # Module only has a dummy test
  doCheck = false;

  meta = {
    description = "Library to interact with the Android TV Remote protocol v2";
    homepage = "https://github.com/tronikos/androidtvremote2";
    changelog = "https://github.com/tronikos/androidtvremote2/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
