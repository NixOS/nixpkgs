{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  vcversioner,
  flask,
  pymongo,
  six,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flask-pymongo";
  version = "2.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "Flask-PyMongo";
    inherit version;
    hash = "sha256-Yg6wLciAil/LkPJsq2y6nWv0l7FQMq48qZ34A2bjMxQ=";
  };

  nativeBuildInputs = [
    setuptools
    vcversioner
  ];

  propagatedBuildInputs = [
    flask
    pymongo
    six
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
