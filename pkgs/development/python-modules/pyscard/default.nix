{ lib, stdenv, fetchPypi, buildPythonPackage, swig, pcsclite, PCSC }:

let
  # Package does not support configuring the pcsc library.
  withApplePCSC = stdenv.isDarwin;
in

buildPythonPackage rec {
  version = "2.0.1";
  pname = "pyscard";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2ba5ed0db0ed3c98e95f9e34016aa3a57de1bc42dd9030b77a546036ee7e46d8";
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

  NIX_CFLAGS_COMPILE = lib.optionalString (! withApplePCSC)
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
