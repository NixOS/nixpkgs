{ lib
, stdenv
, fetchPypi
, buildPythonPackage
, swig
, pcsclite
, PCSC
}:

let
  # Package does not support configuring the pcsc library.
  withApplePCSC = stdenv.isDarwin;
in

buildPythonPackage rec {
  version = "2.0.7";
  pname = "pyscard";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-J4BUUl+nX76LEEYNh+3NA6cK2U1oixE0Xkc5mH+Fwb8=";
  };

  postPatch = if withApplePCSC then ''
    substituteInPlace smartcard/scard/winscarddll.c \
      --replace "/System/Library/Frameworks/PCSC.framework/PCSC" \
                "${PCSC}/Library/Frameworks/PCSC.framework/PCSC"
  '' else ''
    substituteInPlace smartcard/scard/winscarddll.c \
      --replace "libpcsclite.so.1" \
                "${lib.getLib pcsclite}/lib/libpcsclite${stdenv.hostPlatform.extensions.sharedLibrary}"
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString (! withApplePCSC)
    "-I ${lib.getDev pcsclite}/include/PCSC";

  propagatedBuildInputs = if withApplePCSC then [ PCSC ] else [ pcsclite ];
  nativeBuildInputs = [ swig ];

  meta = with lib; {
    homepage = "https://pyscard.sourceforge.io/";
    description = "Smartcard library for python";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ layus ];
  };
}
