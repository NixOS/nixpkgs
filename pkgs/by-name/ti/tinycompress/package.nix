{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "tinycompress";
  version = "1.2.11";

  src = fetchurl {
    url = "mirror://alsa/tinycompress/tinycompress-${version}.tar.bz2";
    hash = "sha256-6754jCgyjnzKJFqvkZSlrQ3JHp4NyIPCz5/rbULJ8/w=";
  };

  meta = with lib; {
    homepage = "http://www.alsa-project.org/";
    description = "Userspace library for anyone who wants to use the ALSA compressed APIs";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ k900 ];
  };
}
