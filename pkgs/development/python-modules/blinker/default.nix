{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  flit-core,

  # tests
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "blinker";
  version = "1.7.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5oIP9vpOTR2OJ0fCKDdJw/VH5P7hErmFVc3NrjKZYYI=";
  };

  nativeBuildInputs = [ flit-core ];

  pythonImportsCheck = [ "blinker" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/pallets-eco/blinker/releases/tag/${version}";
    description = "Fast Python in-process signal/event dispatching system";
    homepage = "https://github.com/pallets-eco/blinker/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
