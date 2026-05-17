{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  python-dateutil,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "beautiful-date";
  version = "2.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "kuzmoyev";
    repo = "beautiful-date";
    tag = "v${version}";
    hash = "sha256-e6YJBaDwWqVehxBPOvsIdV4FIXlIwj29H5untXGJvT0=";
  };

  propagatedBuildInputs = [ python-dateutil ];

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
  };
}
