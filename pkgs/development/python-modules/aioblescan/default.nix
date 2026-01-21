{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aioblescan";
  version = "0.2.14";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "frawau";
    repo = "aioblescan";
    tag = version;
    hash = "sha256-JeA9jX566OSRiejdnlifbcNGm0J0C+xzA6zXDUyZ6jc=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "aioblescan" ];

  meta = {
    description = "Library to listen for BLE advertized packets";
    mainProgram = "aioblescan";
    homepage = "https://github.com/frawau/aioblescan";
    changelog = "https://github.com/frawau/aioblescan/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
