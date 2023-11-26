{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytestCheckHook
, pytest-mypy-plugins
, lxml
}:

buildPythonPackage rec {
  pname = "lxml-stubs";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lxml";
    repo = "lxml-stubs";
    rev = version;
    hash = "sha256-RRH/taLtgaXOl0G/ve2Ad7Xy8WRDUG2/k26EFMv1PRM=";
  };

  nativeBuildInputs = [
    setuptools
  ];
  propagatedBuildInputs = [
    lxml
  ];
  nativeCheckInputs = [
    pytestCheckHook
    pytest-mypy-plugins
  ];

  meta = with lib; {
    description = "Type stubs for the lxml package";
    homepage = "https://github.com/lxml/lxml-stubs";
    license = licenses.asl20;
    maintainers = with maintainers; [ doronbehar ];
  };
}
