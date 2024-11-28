{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  scipy,
  matplotlib,
  pytestCheckHook,
  isPy3k,
}:

buildPythonPackage {
  pname = "filterpy";
  version = "1.4.5-unstable-2022-08-23";
  pyproject = true;

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "rlabbe";
    repo = "filterpy";
    rev = "3b51149ebcff0401ff1e10bf08ffca7b6bbc4a33";
    hash = "sha256-KuuVu0tqrmQuNKYmDmdy+TU6BnnhDxh4G8n9BGzjGag=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
    matplotlib
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # ValueError: Unable to avoid copy while creating an array as requested."
    "test_multivariate_gaussian"
  ];

  meta = with lib; {
    homepage = "https://github.com/rlabbe/filterpy";
    description = "Kalman filtering and optimal estimation library";
    license = licenses.mit;
    maintainers = [ ];
  };
}
