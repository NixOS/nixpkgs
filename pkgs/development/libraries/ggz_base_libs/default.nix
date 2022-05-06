{ lib, stdenv, fetchurl, intltool, openssl, expat, libgcrypt }:

stdenv.mkDerivation rec {
  pname = "ggz-base-libs";
  version = "0.99.5";

  src = fetchurl {
    url = "http://mirrors.ibiblio.org/pub/mirrors/ggzgamingzone/ggz/snapshots/ggz-base-libs-snapshot-${version}.tar.gz";
    sha256 = "1cw1vg0fbj36zyggnzidx9cbjwfc1yr4zqmsipxnvns7xa2awbdk";
  };

  buildInputs = [ intltool openssl expat libgcrypt ];

  patchPhase = ''
    substituteInPlace configure \
      --replace "/usr/local/ssl/include" "${openssl.dev}/include" \
      --replace "/usr/local/ssl/lib" "${lib.getLib openssl}/lib"
  '';

  configureFlags = [
    "--with-tls"
  ];

  meta = with lib; {
    description = "GGZ Gaming zone libraries";
    maintainers = with maintainers;
    [
      raskin
    ];
    platforms = platforms.linux;
    license = licenses.gpl2;
    downloadPage = "http://www.ggzgamingzone.org/releases/";
  };
}
