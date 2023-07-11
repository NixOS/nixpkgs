{ lib, stdenv, fetchpatch, fetchPypi, buildPythonPackage, swig, pcsclite, PCSC }:

let
  # Package does not support configuring the pcsc library.
  withApplePCSC = stdenv.isDarwin;
in

buildPythonPackage rec {
  version = "2.0.2";
  pname = "pyscard";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05de0579c42b4eb433903aa2fb327d4821ebac262434b6584da18ed72053fd9e";
  };

  patches = [
    # present in master - remove after 2.0.2
    (fetchpatch {
      name = "darwin-typo-test-fix.patch";
      url = "https://github.com/LudovicRousseau/pyscard/commit/ce842fcc76fd61b8b6948d0b07306d82ad1ec12a.patch";
      sha256 = "0wsaj87wp9d2vnfzwncfxp2w95m0zhr7zpkmg5jccn06z52ihis3";
    })
  ];

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
