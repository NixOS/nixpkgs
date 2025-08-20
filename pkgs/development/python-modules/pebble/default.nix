{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pebble";
  version = "5.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "noxdafox";
    repo = "pebble";
    tag = version;
    hash = "sha256-Y6E+Mu5Ch+VTHryTY3pvHQD6GzaTLrtf78DqUWa7nt0=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  pythonImportsCheck = [ "pebble" ];

  meta = {
    description = "API to manage threads and processes within an application";
    homepage = "https://github.com/noxdafox/pebble";
    changelog = "https://github.com/noxdafox/pebble/releases/tag/${version}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ orivej ];
  };
}
