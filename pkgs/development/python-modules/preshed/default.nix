{
  lib,
  buildPythonPackage,
  cymem,
  cython,
  fetchPypi,
  murmurhash,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "preshed";
  version = "3.0.10";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WlyOaF6UH0/+yX8fvzJpS4EHhYiRpLw0EH+smB2Clv8=";
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

  meta = with lib; {
    description = "Cython hash tables that assume keys are pre-hashed";
    homepage = "https://github.com/explosion/preshed";
    license = licenses.mit;
    maintainers = [ ];
  };
}
