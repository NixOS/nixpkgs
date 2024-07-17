{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  parts,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "bitlist";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+/rBno+OH7yEiN4K9VC6BCEPuOv8nNp0hU+fWegjqPw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '--cov=bitlist --cov-report term-missing' ""
  '';

  build-system = [
    setuptools
    wheel
  ];

  pythonRelaxDeps = [ "parts" ];

  dependencies = [ parts ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bitlist" ];

  meta = with lib; {
    description = "Python library for working with little-endian list representation of bit strings";
    homepage = "https://github.com/lapets/bitlist";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
