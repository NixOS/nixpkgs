{
  lib,
  buildPythonPackage,
  cymem,
  cython,
  fetchPypi,
  murmurhash,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "preshed";
  version = "3.0.12";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tz+ai1TuHURSnMYBg1aJbP+T1I91XynBNHNNk3HA1oU=";
  };

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [
    cymem
    murmurhash
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Tests have import issues with 3.0.8
  doCheck = false;

  pythonImportsCheck = [ "preshed" ];

  # don't update to 4.0.0, version was yanked
  passthru.skipBulkUpdate = true;

  meta = {
    description = "Cython hash tables that assume keys are pre-hashed";
    homepage = "https://github.com/explosion/preshed";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
