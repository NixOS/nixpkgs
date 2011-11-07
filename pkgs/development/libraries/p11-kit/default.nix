{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "p11-kit-0.7";

  src = fetchurl {
    url = "${meta.homepage}releases/${name}.tar.gz";
    sha256 = "1vj86kc7ir1djlb5akrr3w4x4k7h34pq2l4abwgqmcwxbm4j0lln";
  };

  postInstall = "rm -frv $out/share/gtk-doc";

  meta = {
    homepage = http://p11-glue.freedesktop.org/;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
