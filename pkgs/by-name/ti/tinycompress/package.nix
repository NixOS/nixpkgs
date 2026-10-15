{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tinycompress";
  version = "1.2.13";

  src = fetchurl {
    url = "mirror://alsa/tinycompress/tinycompress-${finalAttrs.version}.tar.bz2";
    hash = "sha256-Dv5svXv/MZg+DUFt8ENnZ2ZcxM1w0njAbODoPg7qtds=";
  };

  meta = {
    homepage = "http://www.alsa-project.org/";
    description = "Userspace library for anyone who wants to use the ALSA compressed APIs";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ k900 ];
  };
})
