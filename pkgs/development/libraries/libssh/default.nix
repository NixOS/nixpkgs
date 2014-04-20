{ stdenv, fetchurl, pkgconfig, cmake, zlib, libgcrypt }:

stdenv.mkDerivation rec {
  name = "libssh-0.6.3";

  src = fetchurl {
    url = "https://red.libssh.org/attachments/download/87/${name}.tar.xz";
    sha256 = "1jyaj9h1iglvn02hrvcchbx8ycjpj8b91h8mi459k7q5jp2xgd9b";
  };

  buildInputs = [ zlib libgcrypt ];

  nativeBuildInputs = [ cmake pkgconfig ];

  cmakeFlags = "-DWITH_GCRYPT=ON";

  meta = {
    description = "SSH client library";
    license = "LGPL";
    maintainers = with stdenv.lib.maintainers; [ sander urkud ];
    platforms = stdenv.lib.platforms.all;
  };
}
