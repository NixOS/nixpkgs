{ stdenv, fetchurl, libiconv, pkgconfig, libffi, libtasn1 }:

stdenv.mkDerivation rec {
  name = "p11-kit-0.20.2";

  src = fetchurl {
    url = "${meta.homepage}releases/${name}.tar.gz";
    sha256 = "0z7gwmsj9hcmpk3ai2lwla59y3h9jc13xmqk5rijnv645zcm3v84";
  };

  postInstall = "rm -frv $out/share/gtk-doc";

  configureFlags = "--without-libtasn1";

  buildInputs = [ libiconv pkgconfig libffi libtasn1 ];

  meta = {
    homepage = http://p11-glue.freedesktop.org/;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
