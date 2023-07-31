{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, setuptools-scm
, wheel
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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'setuptools_scm[toml]>=3.4,<6' 'setuptools_scm[toml]>=3.4'

    # Drop broken version specifier
    sed -i '/python_requires/d' setup.cfg
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

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
    maintainers = [ ];
  };
}
