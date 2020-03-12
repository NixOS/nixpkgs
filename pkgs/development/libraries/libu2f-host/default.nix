{ stdenv, fetchurl, pkgconfig, json_c, hidapi }:

stdenv.mkDerivation rec {
  pname = "libu2f-host";
  version = "1.1.10";

  src = fetchurl {
    url = "https://developers.yubico.com/${pname}/Releases/${pname}-${version}.tar.xz";
    sha256 = "0vrivl1dwql6nfi48z6dy56fwy2z13d7abgahgrs2mcmqng7hra2";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ json_c hidapi ];

  doCheck = true;

  postInstall = ''
    install -D -t $out/lib/udev/rules.d 70-u2f.rules
  '';

  meta = with stdenv.lib; {
    homepage = https://developers.yubico.com/libu2f-host;
    description = "A C library and command-line tool that implements the host-side of the U2F protocol";
    license = with licenses; [ gpl3Plus lgpl21Plus ];
    platforms = platforms.unix;
  };
}
