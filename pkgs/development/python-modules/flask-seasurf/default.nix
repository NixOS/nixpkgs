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

  meta = with lib; {
    description = "Flask extension for preventing cross-site request forgery";
    homepage = "https://github.com/maxcountryman/flask-seasurf";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
