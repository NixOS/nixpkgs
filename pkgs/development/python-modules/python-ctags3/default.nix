<<<<<<< HEAD
{ lib, buildPythonPackage, cython, fetchFromGitHub }:
=======
{ lib, buildPythonPackage, fetchPypi }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildPythonPackage rec {
  pname = "python-ctags3";
  version = "1.5.0";

<<<<<<< HEAD
  src = fetchFromGitHub {
    owner = "universal-ctags";
    repo = pname;
    rev = version;
    hash = "sha256-XVsZckNVJ1H5q8FzqoVd1UWRw0zOygvRtb7arX9dwGE=";
  };

  nativeBuildInputs = [
    cython
  ];

  # Regenerating the bindings keeps later versions of Python happy
  postPatch = ''
    cython src/_readtags.pyx
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Ctags indexing python bindings";
=======
  src = fetchPypi {
    inherit pname version;
    sha256 = "a2cb0b35f0d67bab47045d803dce8291a1500af11832b154f69b3785f2130daa";
  };

  meta = with lib; {
    description = "Ctags indexing python bindings";
    homepage = "https://github.com/jonashaag/python-ctags3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.lgpl3Plus;
  };
}
