{
  lib,
  buildPythonPackage,
  poetry-core,
  fetchFromGitHub,
  pytestCheckHook,
  msgspec,
  numpy,
  pandas,
  pydantic,
  scikit-learn,
  scipy,
  toolz,
}:

buildPythonPackage rec {

  pname = "saiph";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "octopize";
    repo = "saiph";
    rev = "saiph-v" + version;
    hash = "sha256-Qj94N2Y5n9bXXij1twqlh1fCcbrA6L9zazAT1Tsfmsw=";
  };

  pyproject = true;

  build-system = [
    poetry-core
  ];

  propagatedBuildInputs = [
    msgspec
    numpy
    pandas
    pydantic
    scikit-learn
    scipy
    toolz
  ];

  pythonImportsCheck = [ "saiph" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A projection package";
    homepage = "https://github.com/octopize/saiph/tree/main";
    license = licenses.asl20;
    maintainers = with maintainers; [ b-rodrigues ];
  };
}
