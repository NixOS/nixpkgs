{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "tinycompress";
  version = "1.2.13";

  src = fetchurl {
    url = "mirror://alsa/tinycompress/tinycompress-${version}.tar.bz2";
    hash = "sha256-Dv5svXv/MZg+DUFt8ENnZ2ZcxM1w0njAbODoPg7qtds=";
  };

  meta = with lib; {
    homepage = "http://www.alsa-project.org/";
    description = "Userspace library for anyone who wants to use the ALSA compressed APIs";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ k900 ];
  };
}
