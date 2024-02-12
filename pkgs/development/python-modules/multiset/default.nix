{ lib
, buildPythonPackage
, fetchpatch
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

  patches = [
    # https://github.com/wheerd/multiset/pull/115
    (fetchpatch {
      name = "relax-setuptools-scm-dependency.patch";
      url = "https://github.com/wheerd/multiset/commit/296187b07691c94b783f65504afc580a355abd96.patch";
      hash = "sha256-vnZR1cyM/2/JfbLuVOxJuC9oMVVVploUHpbzagmo+AE=";
    })
  ];

  postPatch = ''
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
