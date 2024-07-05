{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "multiset";
  version = "3.1.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jpPlhvaI0uKwD6WEPiqC9p6XHhrHrT14+dKkdgjem6Y=";
  };

  postPatch = ''
    # Drop broken version specifier
    sed -i '/python_requires/d' setup.cfg
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [ "multiset" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Implementation of a multiset";
    homepage = "https://github.com/wheerd/multiset";
    license = licenses.mit;
    maintainers = [ ];
  };
}
