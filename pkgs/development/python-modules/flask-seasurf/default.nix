{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  flask,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flask-seasurf";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maxcountryman";
    repo = "flask-seasurf";
    tag = version;
    hash = "sha256-ajQiDizNaF0em9CVeaHEuJEeSaYraJh9YgvhvBPTIsk=";
  };

  build-system = [ setuptools ];

  dependencies = [ flask ];

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  pythonImportsCheck = [ "flask_seasurf" ];

  meta = {
    description = "Flask extension for preventing cross-site request forgery";
    homepage = "https://github.com/maxcountryman/flask-seasurf";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ zhaofengli ];
  };
}
