{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  bleak,
  bleak-retry-connector,
  construct,
  dbus-fast,
  pytest-asyncio,
  pytestCheckHook,
  stdenv,
}:

buildPythonPackage (finalAttrs: {
  pname = "hueble";
  version = "2.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "flip-dots";
    repo = "HueBLE";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+d81XiZ5Ue8XO/SuztD6GMx3WHsCbOfr2XPfDsdY5Ss=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bleak
    bleak-retry-connector
    construct
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    dbus-fast
  ];

  pythonImportsCheck = [ "HueBLE" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/flip-dots/HueBLE/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    description = "Python module for controlling Bluetooth Philips Hue lights";
    homepage = "https://github.com/flip-dots/HueBLE";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
