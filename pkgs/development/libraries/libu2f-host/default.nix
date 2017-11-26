{ stdenv, fetchurl, pkgconfig, json_c, hidapi }:

stdenv.mkDerivation rec {
  name = "libu2f-host-1.1.4";

  src = fetchurl {
    url = "https://developers.yubico.com/libu2f-host/Releases/${name}.tar.xz";
    sha256 = "0vvs2p3b25cbybccv3f4ridnp7sg5i4hkzx3hx48ldcn1l1fqhv0";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ json_c hidapi ];

  doCheck = true;

  postInstall = ''
    install -D -t $out/lib/udev/rules.d 70-u2f.rules
  '';

  meta = with stdenv.lib; {
    homepage = https://developers.yubico.com/libu2f-host;
    description = "A C library and command-line tool thati mplements the host-side of the U2F protocol";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
