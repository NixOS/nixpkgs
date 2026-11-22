{
  lib,
  buildPythonPackage,
  cymem,
  cython_3_2,
  fetchPypi,
  murmurhash,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "preshed";
  version = "3.0.15";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-R8bM2eK1Y59Zg6FkW7Jw6IEpZMA/I+mJ7nmWxkaR/cg=";
  };

  nativeBuildInputs = [ cython_3_2 ];

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
