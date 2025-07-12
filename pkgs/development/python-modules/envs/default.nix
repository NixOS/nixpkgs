{
  lib,
  buildPythonPackage,
  click,
  fetchPypi,
  jinja2,
  pytestCheckHook,
  poetry-core,
  terminaltables,
}:

buildPythonPackage rec {
  pname = "envs";
  version = "1.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nYQ1xphdHN1oKZ4ExY4r24rmz2ayWWqAeeb5qT8qA5g=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    click
    jinja2
    terminaltables
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "envs/tests.py" ];

  disabledTests = [ "test_list_envs" ];

  pythonImportsCheck = [ "envs" ];

  meta = {
    description = "Easy access to environment variables from Python";
    mainProgram = "envs";
    homepage = "https://github.com/capless/envs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ peterhoeg ];
  };
}
