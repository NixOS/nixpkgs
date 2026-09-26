{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tkrzw";
  version = "1.0.33";
  # TODO: defeat multi-output reference cycles

  src = fetchurl {
    url = "https://dbmx.net/tkrzw/pkg/tkrzw-${finalAttrs.version}.tar.gz";
    hash = "sha256-+qQf2taieuEfvynRhcFCdh6outSuiTgtFszD8vrg45w=";
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
