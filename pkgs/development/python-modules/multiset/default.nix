{ lib
, buildPythonPackage
<<<<<<< HEAD
, fetchpatch
, fetchPypi
, setuptools
, setuptools-scm
, wheel
=======
, fetchPypi
, setuptools
, setuptools-scm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  patches = [
    # https://github.com/wheerd/multiset/pull/115
    (fetchpatch {
      name = "relax-setuptools-scm-dependency.patch";
      url = "https://github.com/wheerd/multiset/commit/296187b07691c94b783f65504afc580a355abd96.patch";
      hash = "sha256-vnZR1cyM/2/JfbLuVOxJuC9oMVVVploUHpbzagmo+AE=";
    })
=======
  nativeBuildInputs = [
    setuptools
    setuptools-scm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  postPatch = ''
    # Drop broken version specifier
    sed -i '/python_requires/d' setup.cfg
  '';

<<<<<<< HEAD
  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = [ ];
=======
    maintainers = [ maintainers.costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
