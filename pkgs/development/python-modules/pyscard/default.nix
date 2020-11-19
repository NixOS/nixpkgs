{ stdenv, fetchPypi, fetchpatch, buildPythonPackage, swig, pcsclite, PCSC }:

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

  # The error message differs depending on the macOS host version.
  # Since Nix reports a constant host version, but proxies to the
  # underlying library, it's not possible to determine the correct
  # expected error message.  This patch allows both errors to be
  # accepted.
  # See: https://github.com/LudovicRousseau/pyscard/issues/77
  # Building with python from nix on macOS version 10.13 or
  # greater still causes this issue to occur.
  patches = optionals withApplePCSC [
    (fetchpatch {
      url = "https://github.com/LudovicRousseau/pyscard/commit/945e9c4cd4036155691f6ce9706a84283206f2ef.patch";
      sha256 = "19n8w1wzn85zywr6xf04d8nfg7sgzjyvxp1ccp3rgfr4mcc36plc";
    })
  ];

  propagatedBuildInputs = if withApplePCSC then [ PCSC ] else [ pcsclite ];
  nativeBuildInputs = [ swig ];

  meta = {
    homepage = "https://pyscard.sourceforge.io/";
    description = "Smartcard library for python";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = with stdenv.lib.maintainers; [ layus ];
  };
}
