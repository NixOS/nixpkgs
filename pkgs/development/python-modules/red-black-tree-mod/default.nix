{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "red-black-tree-mod";
  version = "1.22";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OONlKQOiv5Y3nCfCCCygt7kFFYZi3X7wyX9P2TqaqQg=";
  };

  nativeBuildInputs = [ setuptools ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [ "red_black_dict_mod" ];

  meta = with lib; {
    description = "Flexible python implementation of red black trees";
    homepage = "https://stromberg.dnsalias.org/~strombrg/red-black-tree-mod/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
