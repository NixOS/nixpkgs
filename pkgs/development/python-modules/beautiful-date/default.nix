{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  freezegun,
  python-dateutil,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "beautiful-date";
  version = "2.3.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kuzmoyev";
    repo = "beautiful-date";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e6YJBaDwWqVehxBPOvsIdV4FIXlIwj29H5untXGJvT0=";
  };

  build-system = [ setuptools ];

  dependencies = [ python-dateutil ];

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [ "beautiful_date" ];

  meta = {
    description = "Simple and beautiful way to create date and datetime objects";
    homepage = "https://github.com/kuzmoyev/beautiful-date";
    license = lib.licenses.mit;
    maintainers = [ ];
    hasNoMaintainersButDependents = true;
  };
})
