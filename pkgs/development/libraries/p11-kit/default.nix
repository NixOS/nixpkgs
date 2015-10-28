{ stdenv, fetchurl, libiconv, pkgconfig, libffi, libtasn1 }:

stdenv.mkDerivation rec {
  name = "p11-kit-0.23.1";

  src = fetchurl {
    url = "${meta.homepage}releases/${name}.tar.gz";
    sha256 = "1i3a1wdpagm0p3y1bwaz5x5rjhcpqbcrnhkcp10p259vkxk72wz5";
  };

  outputs = [ "dev" "out" "docdev" ];
  outputBin = "dev";

  buildInputs = [ pkgconfig libffi libtasn1 libiconv ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--without-trust-paths"
  ];

  installFlags = [ "exampledir=\${out}/etc/pkcs11" ];

  meta = with stdenv.lib; {
    homepage = http://p11-glue.freedesktop.org/;
    platforms = platforms.all;
    maintainers = with maintainers; [ urkud wkennington ];
    license = licenses.mit;
  };
}
