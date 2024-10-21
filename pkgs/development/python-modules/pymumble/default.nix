{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  opuslib,
  protobuf,
  pytestCheckHook,
  pycrypto,
  pythonOlder,
}:

buildPythonPackage {
  pname = "pymumble";
  version = "unstable-2024-10-20";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tjni";
    repo = "pymumble";
    rev = "3241e84e5ce162a20597e4df6a9c443122357fec";
    hash = "sha256-9lfWvfrS+vUFTf9jo4T+VHkm9u/hVjsDszLBQIEZVcQ=";
  };

  propagatedBuildInputs = [
    opuslib
    protobuf
  ];

  nativeCheckInputs = [
    pycrypto
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pymumble_py3"
    "pymumble_py3.constants"
  ];

  meta = with lib; {
    description = "Library to create mumble bots";
    homepage = "https://github.com/tjni/pymumble";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      thelegy
      tjni
    ];
  };
}
