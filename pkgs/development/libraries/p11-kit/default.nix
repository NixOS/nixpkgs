{ stdenv, fetchurl, libiconv, pkgconfig, libffi, libtasn1 }:

stdenv.mkDerivation rec {
  name = "p11-kit-0.20.1";

  src = fetchurl {
    url = "${meta.homepage}releases/${name}.tar.gz";
    sha256 = "0lsaxd1rg74ax1vkclq7r52b43rhy14mn5i14xqvb8dzlgq4hiaj";
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
