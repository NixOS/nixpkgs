{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "btsocket";
  version = "0.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ukBaz";
    repo = "python-btsocket";
    tag = "v${version}";
    hash = "sha256-/T89GZJth7pBGQuN1ytCf649oWv7aZcfPHjYoftbLw8=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "btsocket" ];

  meta = {
    description = "Library to interact with the Bluez Bluetooth Management API";
    homepage = "https://github.com/ukBaz/python-btsocket";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
