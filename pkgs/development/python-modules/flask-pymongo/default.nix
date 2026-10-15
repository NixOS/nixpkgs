{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  flask,
  pymongo,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flask-pymongo";
  version = "3.0.1";
  pyproject = true;

  src = fetchPypi {
    pname = "flask_pymongo";
    inherit version;
    hash = "sha256-0iW1HCHOyi5nDmzKebXFhK0XuWJStI6E47Qj3bczBMw=";
  };

  build-system = [ hatchling ];

  dependencies = [
    flask
    pymongo
  ];

  pythonImportsCheck = [ "flask_pymongo" ];

  nativeCheckInputs = [ pytestCheckHook ];

  # requires running MongoDB
  doCheck = false;

  meta = {
    homepage = "https://github.com/dcrosta/flask-pymongo";
    description = "PyMongo support for Flask applications";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
