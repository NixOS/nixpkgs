{ stdenv, fetchPypi, fetchpatch, buildPythonPackage, swig, pcsclite, PCSC }:

let
  # Package does not support configuring the pcsc library.
  withApplePCSC = stdenv.isDarwin;

  inherit (stdenv.lib) getLib getDev optionalString optionals;
  inherit (stdenv.hostPlatform.extensions) sharedLibrary;
in

buildPythonPackage rec {
  version = "1.9.8";
  pname = "pyscard";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15fh00z1an6r5j7hrz3jlq0rb3jygwf3x4jcwsa008bv8vpcg7gm";
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

  # The error message differs depending on the macOS host version.
  # Since Nix reports a constant host version, but proxies to the
  # underlying library, it's not possible to determine the correct
  # expected error message.  This patch allows both errors to be
  # accepted.
  # See: https://github.com/LudovicRousseau/pyscard/issues/77
  patches = optionals withApplePCSC [ ./ignore-macos-bug.patch ];

  propagatedBuildInputs = if withApplePCSC then [ PCSC ] else [ pcsclite ];
  nativeBuildInputs = [ swig ];

  meta = {
    homepage = https://pyscard.sourceforge.io/;
    description = "Smartcard library for python";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ layus ];
  };
}
