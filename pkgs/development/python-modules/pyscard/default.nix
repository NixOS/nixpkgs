{ stdenv, fetchPypi, buildPythonPackage, swig, pcsclite, PCSC }:

let
  # Package does not support configuring the pcsc library.
  withApplePCSC = stdenv.isDarwin;

  inherit (stdenv.lib) getLib getDev optionalString optionals;
  inherit (stdenv.hostPlatform.extensions) sharedLibrary;
in

buildPythonPackage rec {
  version = "2.0.0";
  pname = "pyscard";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yap0p8mp6dx58n3nina6ryhc2cysaj75sq98wf3qybf33cxjr5k";
  };

  postPatch = if withApplePCSC then ''
    substituteInPlace smartcard/scard/winscarddll.c \
      --replace "/System/Library/Frameworks/PCSC.framework/PCSC" \
                "${PCSC}/Library/Frameworks/PCSC.framework/PCSC"
  '' else ''
    substituteInPlace smartcard/scard/winscarddll.c \
      --replace "libpcsclite.so.1" \
                "${getLib pcsclite}/lib/libpcsclite${sharedLibrary}"
  '';

  NIX_CFLAGS_COMPILE = optionalString (! withApplePCSC)
    "-I ${getDev pcsclite}/include/PCSC";

  propagatedBuildInputs = if withApplePCSC then [ PCSC ] else [ pcsclite ];
  nativeBuildInputs = [ swig ];

  meta = {
    homepage = "https://pyscard.sourceforge.io/";
    description = "Smartcard library for python";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ layus ];
  };
}
