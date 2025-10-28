{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "juliandate";
  version = "1.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "seanredmond";
    repo = "juliandate";
    tag = "v${version}";
    hash = "sha256-pOWyrPBFqKmG9oKbXY/L14LblIcc8KfZSqZAEQP29V8=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "juliandate" ];

  meta = {
    description = "Conversions between Julian Dates and Julian/Gregorian calendar dates";
    homepage = "https://github.com/seanredmond/juliandate";
    changelog = "https://github.com/seanredmond/juliandate/blob/v${src.tag}/HISTORY.MD";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
