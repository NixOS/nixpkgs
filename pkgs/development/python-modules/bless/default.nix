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
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "bless";
  version = "0.2.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kevincar";
    repo = "bless";
    tag = "v${version}";
    hash = "sha256-dAdA+d75iE6v6t4mfgvwhRsIARLW+IqCGmaMABaDlZg=";
  };

  postPatch = ''
    sed -i "/pysetupdi/d" setup.py
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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

  meta = with lib; {
    broken = true; # not compatible with bleak>=1.0 and no maintenance since 2024-03
    description = "Library for creating a BLE Generic Attribute Profile (GATT) server";
    homepage = "https://github.com/kevincar/bless";
    changelog = "https://github.com/kevincar/bless/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
