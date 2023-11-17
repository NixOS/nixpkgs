{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "tinycompress";
  version = "1.2.8";

  src = fetchurl {
    url = "mirror://alsa/tinycompress/${pname}-${version}.tar.bz2";
    hash = "sha256-L4l+URLNO8pnkLXOz9puBmLIvF7g+6uXKyR6DMYg1mw=";
  };

  meta = with lib; {
    homepage = "http://www.alsa-project.org/";
    description = "a userspace library for anyone who wants to use the ALSA compressed APIs";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ k900 ];
  };
}
