{ lib, stdenv, buildPythonPackage, pythonOlder, fetchPypi, setuptools
, pytestCheckHook, poetry-core, numpy }:

buildPythonPackage rec {
  pname = "detecta";
  version = "0.0.5";
  pyproject = true;

  disabled = pythonOlder "3.10";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0up9E9+7yZTWzjhaf43AqF/mdaio5xKmTsVuVMQGA+0=";
  };

  nativeBuildInputs = [ setuptools poetry-core ];

  propagatedBuildInputs = [ numpy ];

  nativeCheckinputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "detecta" ];

  meta = with lib; {
    changelog = "https://github.com/demotu/detecta/releases/tag/${version}";
    description = "A Python module to detect events in data";
    homepage = "https://github.com/demotu/detecta";
    license = licenses.mit;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
