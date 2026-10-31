{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tkrzw";
  version = "1.0.34";
  # TODO: defeat multi-output reference cycles

  src = fetchurl {
    url = "https://dbmx.net/tkrzw/pkg/tkrzw-${finalAttrs.version}.tar.gz";
    hash = "sha256-r+iUwVMv7aCGt6lGcvQS+AF1jL6BQx/TyIUU+ifr42k=";
  };

  postPatch = ''
    substituteInPlace configure \
      --replace 'PATH=".:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:$PATH"' ""
  '';

  enableParallelBuilding = true;

  doCheck = false; # memory intensive

  meta = {
    description = "Set of implementations of DBM";
    homepage = "https://dbmx.net/tkrzw/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})
