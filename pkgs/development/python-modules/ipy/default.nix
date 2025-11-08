{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ipy";
  version = "1.01";
  pyproject = true;

  src = fetchPypi {
    pname = "IPy";
    inherit version;
    hash = "sha256-7eynQd6i1UrKVo+iN0AojD/obA8+pwA0RXHp7xSnzBo=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "IPy" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Class and tools for handling of IPv4 and IPv6 addresses and networks";
    homepage = "https://github.com/autocracy/python-ipy";
    license = licenses.bsdOriginal;
  };
}
