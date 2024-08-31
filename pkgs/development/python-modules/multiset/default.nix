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
  version = "3.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fFmnhihLnDOd9PIZ3LtM5fRNOsGyD5ImNsTXieic97U=";
  };

  postPatch = ''
    # Drop broken version specifier
    sed -i '/python_requires/d' setup.cfg
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "multiset" ];

  meta = with lib; {
    description = "Implementation of a multiset";
    homepage = "https://github.com/wheerd/multiset";
    changelog = "https://github.com/wheerd/multiset/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
