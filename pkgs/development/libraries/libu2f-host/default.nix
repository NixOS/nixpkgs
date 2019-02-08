{ stdenv, fetchurl, pkgconfig, json_c, hidapi }:

stdenv.mkDerivation rec {
  name = "libu2f-host-1.1.6";

  src = fetchurl {
    url = "https://developers.yubico.com/libu2f-host/Releases/${name}.tar.xz";
    sha256 = "19xxwwqfzg3njfpxvhlyxd05wjwsdw3m4lpn7gk31cna6agbp82d";
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
