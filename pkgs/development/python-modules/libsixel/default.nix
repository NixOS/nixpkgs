{
  buildPythonPackage,
  lib,
  stdenv,
  libsixel,
}:

buildPythonPackage rec {
  version = libsixel.version;
  format = "setuptools";
  pname = "libsixel";

  src = libsixel.src;
  sourceRoot = "${src.name}/python";

  prePatch = ''
    substituteInPlace libsixel/__init__.py --replace \
      'from ctypes.util import find_library' \
      'find_library = lambda _x: "${lib.getLib libsixel}/lib/libsixel${stdenv.hostPlatform.extensions.sharedLibrary}"'
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
