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
  version = "1.8.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-j3ewnTv3x5XpaelIbznCxenDnU7gdCS+K8WU7OlkLYM=";
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
    maintainers = [ ];
  };
}
