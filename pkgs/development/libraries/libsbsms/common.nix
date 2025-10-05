{
  lib,
  stdenv,
  fetchurl,
  replaceVars,
  pname,
  version,
  url,
  sha256,
  homepage,
}:

stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    inherit url sha256;
  };

  patches = [
    # Fix building on platforms other than x86
    (replaceVars ./configure.patch {
      msse = lib.optionalString stdenv.hostPlatform.isx86_64 "-msse";
    })
  ];

  doCheck = true;

  meta = {
    inherit homepage;
    description = "Subband sinusoidal modeling library for time stretching and pitch scaling audio";
    maintainers = [ ];
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
  };
}
