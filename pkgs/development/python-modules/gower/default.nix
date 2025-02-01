{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  scipy,
  pandas,
}:

buildPythonPackage rec {

  pname = "gower";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wwwjk366";
    repo = "gower";
    rev = "d92f2145e65efe305143e9e30cc69b722d1c52e3";
    hash = "sha256-9S4uUEuntKyFbUY4wdYshsVT5Cssc/MCHqOnKHwZoVI=";
  };

  patches = [
    ./fix-pyproject_toml.patch
  ];

  build-system = [ setuptools ];

  dependencies = [
    scipy
    pandas
  ];

  pythonImportsCheck = [ "gower" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Gower's distance calculation in Python";
    homepage = "https://github.com/wwwjk366/gower";
    license = licenses.mit;
    maintainers = with maintainers; [ b-rodrigues ];
  };
}
