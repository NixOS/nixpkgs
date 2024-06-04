{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  blinker,
  flask,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "flask-principal";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pallets-eco";
    repo = "flask-principal";
    rev = "refs/tags/${version}";
    hash = "sha256-E9urzZc7/QtzAohSNAJsQtykrplb+MC189VGZI5kmEE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    flask
    blinker
  ];

  pythonImportsCheck = [ "flask_principal" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "test_principal.py" ];

  meta = with lib; {
    homepage = "http://packages.python.org/Flask-Principal/";
    description = "Identity management for flask";
    license = licenses.bsd2;
    maintainers = with maintainers; [ abbradar ];
  };
}
