{ buildPythonPackage
, lib
<<<<<<< HEAD
, stdenv
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, libsixel
}:

buildPythonPackage rec {
  version = libsixel.version;
  pname = "libsixel";

  src = libsixel.src;
  sourceRoot = "${src.name}/python";

  prePatch = ''
    substituteInPlace libsixel/__init__.py --replace \
      'from ctypes.util import find_library' \
<<<<<<< HEAD
      'find_library = lambda _x: "${lib.getLib libsixel}/lib/libsixel${stdenv.hostPlatform.extensions.sharedLibrary}"'
=======
      'find_library = lambda _x: "${lib.getLib libsixel}/lib/libsixel.so"'
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "libsixel" ];

  meta = with lib; {
    description = "SIXEL graphics encoder/decoder implementation";
    homepage = "https://github.com/libsixel/libsixel";
    license = licenses.mit;
    maintainers = with maintainers; [ rmcgibbo ];
  };
}
