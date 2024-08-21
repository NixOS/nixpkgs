{
  lib,
  buildPythonPackage,
  fetchPypi,
  networkx,
  numpy,
  pydot,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "pyformlang";
  version = "1.0.10";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VwsIkVIgRHczdT3QcW9Teg2FiaoPn6El17VHhy/x72s=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    networkx
    numpy
    pydot
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyformlang" ];

  meta = with lib; {
    description = "Framework for formal grammars";
    homepage = "https://github.com/Aunsiels/pyformlang";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
