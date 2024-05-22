{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, flit-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "handy-archives";
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "domdfcoding";
    repo = "handy-archives";
    rev = "v${version}";
    hash = "sha256-HRbACvYpOZtfUCbt0efoHBbTO404UFKYluvVHSybGdI=";
  };

  build-system = [
    flit-core
  ];

  pythonImportsCheck = [ "handy_archives" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # requires coincidence which hasn't been packaged yet
  doCheck = false;

  meta = {
    description = "Some handy archive helpers for Python";
    homepage = "https://github.com/domdfcoding/handy-archives";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
