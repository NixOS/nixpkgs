<<<<<<< HEAD
{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, mpv
, setuptools
=======
{ lib, stdenv, buildPythonPackage, fetchFromGitHub, python, isPy27
, mpv
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "mpv";
<<<<<<< HEAD
  version = "1.0.4";
  format = "pyproject";
=======
  version = "1.0.1";
  disabled = isPy27;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jaseg";
    repo = "python-mpv";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-qP5Biw4sTLioAhmMZX+Pemue2PWc3N7afAe38dwJv3U=";
  };

  nativeBuildInputs = [
    setuptools
  ];

=======
    hash = "sha256-UCJ1PknnWQiFciTEMxTUqDzz0Z8HEWycLuQqYeyQhoM=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [ mpv ];

  postPatch = ''
    substituteInPlace mpv.py \
      --replace "sofile = ctypes.util.find_library('mpv')" \
                'sofile = "${mpv}/lib/libmpv${stdenv.targetPlatform.extensions.sharedLibrary}"'
  '';

  # tests impure, will error if it can't load libmpv.so
  doCheck = false;
  pythonImportsCheck = [ "mpv" ];

  meta = with lib; {
    description = "A python interface to the mpv media player";
    homepage = "https://github.com/jaseg/python-mpv";
    license = licenses.agpl3Plus;
<<<<<<< HEAD
    maintainers = with maintainers; [ onny ];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
