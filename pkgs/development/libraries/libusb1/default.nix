{ stdenv, fetchurl, pkgconfig, systemd ? null, libobjc, IOKit }:

stdenv.mkDerivation rec {
  name = "libusb-1.0.20";

  src = fetchurl {
    url = "mirror://sourceforge/libusb/${name}.tar.bz2";
    sha256 = "1zzp6hc7r7m3gl6zjbmzn92zkih4664cckaf49l1g5hapa8721fb";
  };

  outputs = [ "out" "dev" ]; # get rid of propagating systemd closure

  buildInputs = [ pkgconfig ];
  propagatedBuildInputs =
    stdenv.lib.optional stdenv.isLinux systemd ++
    stdenv.lib.optionals stdenv.isDarwin [ libobjc IOKit ];

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

  preFixup = stdenv.lib.optionalString stdenv.isLinux ''
    sed 's,-ludev,-L${systemd.lib}/lib -ludev,' -i $out/lib/libusb-1.0.la
  '';

  meta = {
    homepage = http://www.libusb.info;
    description = "User-space USB library";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ ];
  };
}
