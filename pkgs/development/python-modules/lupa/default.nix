{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lupa";
  version = "2.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UwDSH4GqG9TUX1XjHd26O4eYlWlgaKP4TPy1/ZFIqs0=";
  };

  build-system = [
    cython
    setuptools
  ];

  pythonImportsCheck = [ "lupa" ];

  meta = with lib; {
    description = "Lua in Python";
    homepage = "https://github.com/scoder/lupa";
    changelog = "https://github.com/scoder/lupa/blob/lupa-${version}/CHANGES.rst";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
