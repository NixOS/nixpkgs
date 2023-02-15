{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "0.2.0";
  pname = "ifaddr";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zAy/yqv3ZdRFlYJfuWqZuxLHlxa3O0QzDqOO4rDErtQ=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ifaddr" ];

  meta = with lib; {
    homepage = "https://github.com/pydron/ifaddr";
    description = "Enumerates all IP addresses on all network adapters of the system";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
