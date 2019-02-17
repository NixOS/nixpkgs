{ stdenv, fetchurl, pkgconfig, json_c, hidapi }:

stdenv.mkDerivation rec {
  name = "libu2f-host-1.1.7";

  src = fetchurl {
    url = "https://developers.yubico.com/libu2f-host/Releases/${name}.tar.xz";
    sha256 = "1zyws91b1fsbfwn3f23ry9a9zr0i1a1hqmhk3v1qnlvp56gjayli";
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
    license = licenses.bsd2;
    platforms = platforms.unix;
  };
}
