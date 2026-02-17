{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lupa";
  version = "2.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mncKbolXa+NEdmjXztMSzW/UHTwTwkYsncLCq1cORdk=";
  };

  build-system = [
    cython
    setuptools
  ];

  pythonImportsCheck = [ "lupa" ];

  meta = {
    description = "Lua in Python";
    homepage = "https://github.com/scoder/lupa";
    changelog = "https://github.com/scoder/lupa/blob/lupa-${version}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
