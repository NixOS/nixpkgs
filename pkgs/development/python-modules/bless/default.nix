{
  lib,
  aioconsole,
  bleak,
  buildPythonPackage,
  dbus-next,
  fetchFromGitHub,
  numpy,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "bless";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kevincar";
    repo = "bless";
    tag = "v${version}";
    hash = "sha256-Ks7+OYSrPjXgpCrEEJayxp5Gn84SZbdbyc5c3ZMBEwI=";
  };

  postPatch = ''
    sed -i -e '22,25d' setup.py
  '';

  build-system = [ setuptools ];

  dependencies = [
    bleak
    dbus-next
  ];

  nativeCheckInputs = [
    aioconsole
    numpy
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bless" ];

  meta = {
    description = "Library for creating a BLE Generic Attribute Profile (GATT) server";
    homepage = "https://github.com/kevincar/bless";
    changelog = "https://github.com/kevincar/bless/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
