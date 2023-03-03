{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "multiset";
  version = "3.0.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5FZxyug4Wo5iSKmwejqDKAwtDMQxJxMFjPus3F7Jlz4=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  postPatch = ''
    # Drop broken version specifier
    sed -i '/python_requires/d' setup.cfg
  '';

  pythonImportsCheck = [
    "multiset"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "An implementation of a multiset";
    homepage = "https://github.com/wheerd/multiset";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
