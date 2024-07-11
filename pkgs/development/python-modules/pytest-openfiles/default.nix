{
  lib,
  buildPythonPackage,
  fetchpatch,
  fetchPypi,
  isPy27,
  packaging,
  pytest,
  pytestCheckHook,
  psutil,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-openfiles";
  version = "0.5.0";
  format = "setuptools";
  disabled = isPy27; # abandoned

  src = fetchPypi {
    inherit pname version;
    sha256 = "179c2911d8aee3441fee051aba08e0d9b4dab61b829ae4811906d5c49a3b0a58";
  };

  patches = [
    (fetchpatch {
      name = "replace-distutils-with-packaging.patch";
      url = "https://github.com/astropy/pytest-openfiles/commit/e17e8123936689b0b0ecfb713976588d6793d8bb.patch";
      includes = [ "pytest_openfiles/plugin.py" ];
      hash = "sha256-+6xqOwnBO+jxenXxPdDhLqqm3w+ZRjWeVqqgz8j22bU=";
    })
  ];

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    packaging
    psutil
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Pytest plugin for detecting inadvertent open file handles";
    homepage = "https://astropy.org";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
