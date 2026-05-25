{
  lib,
  stdenv,
  buildPythonPackage,
  defusedxml,
  deprecated,
  fetchFromGitHub,
  lxml,
  paramiko,
  psutil,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ospd";
  version = "21.4.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "ospd";
    tag = "v${version}";
    hash = "sha256-dZgs+G2vJQIKnN9xHcNeNViG7mOIdKb+Ms2AKE+FC4M=";
  };

  propagatedBuildInputs = [
    defusedxml
    deprecated
    lxml
    paramiko
    psutil
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ospd" ];

  meta = {
    description = "Framework for vulnerability scanners which support OSP";
    homepage = "https://github.com/greenbone/ospd";
    changelog = "https://github.com/greenbone/ospd/releases/tag/v${version}";
    license = with lib.licenses; [ agpl3Plus ];
    maintainers = with lib.maintainers; [ fab ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
