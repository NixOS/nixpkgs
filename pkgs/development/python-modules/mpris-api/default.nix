{
  lib,
  buildPythonPackage,
  dbus-next,
  fetchFromBitbucket,
  pytestCheckHook,
  setuptools,
  tunit,
  unidecode,
}:

buildPythonPackage (finalAttrs: {
  pname = "mpris-api";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromBitbucket {
    owner = "massultidev";
    repo = "mpris-api";
    tag = finalAttrs.version;
    hash = "sha256-tr1McOBGTKUVLFToFmb6j8NUzl5bCH8XsNgzZT9Jv7s=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dbus-next
    unidecode
    tunit
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mpris_api" ];

  meta = {
    description = "Module provides an implementation of MPRIS DBus interface";
    homepage = "https://bitbucket.org/massultidev/mpris-api/src/master/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
