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
  version = "5.1.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "noxdafox";
    repo = "pebble";
    tag = version;
    hash = "sha256-x0jvqH1wSAkOgxYNcXr+TL5dqZE0Vai0ZaxdnDSqRNI=";
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
    changelog = "https://github.com/noxdafox/pebble/releases/tag/${src.tag}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ orivej ];
  };
}
