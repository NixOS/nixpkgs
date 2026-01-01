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
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  setuptools,
}:

buildPythonPackage rec {
  pname = "bless";
<<<<<<< HEAD
  version = "0.3.0";
  pyproject = true;

=======
  version = "0.2.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "kevincar";
    repo = "bless";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Ks7+OYSrPjXgpCrEEJayxp5Gn84SZbdbyc5c3ZMBEwI=";
  };

  postPatch = ''
    sed -i -e '22,25d' setup.py
  '';

  build-system = [ setuptools ];

  dependencies = [
=======
    hash = "sha256-dAdA+d75iE6v6t4mfgvwhRsIARLW+IqCGmaMABaDlZg=";
  };

  postPatch = ''
    sed -i "/pysetupdi/d" setup.py
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Library for creating a BLE Generic Attribute Profile (GATT) server";
    homepage = "https://github.com/kevincar/bless";
    changelog = "https://github.com/kevincar/bless/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    broken = true; # not compatible with bleak>=1.0 and no maintenance since 2024-03
    description = "Library for creating a BLE Generic Attribute Profile (GATT) server";
    homepage = "https://github.com/kevincar/bless";
    changelog = "https://github.com/kevincar/bless/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
