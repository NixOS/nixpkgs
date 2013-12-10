{ stdenv, fetchurl, pkgconfig, glib, zlib, libgpgerror }:

stdenv.mkDerivation rec {
  name = "gmime-2.6.19";

  src = fetchurl {
    url = "mirror://gnome/sources/gmime/2.6/${name}.tar.xz";
    sha256 = "0jm1fgbjgh496rsc0il2y46qd4bqq2ln9168p4zzh68mk4ml1yxg";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib zlib libgpgerror ];

  meta = {
    homepage = http://spruce.sourceforge.net/gmime/;
    description = "A C/C++ library for manipulating MIME messages";
    maintainers = [ stdenv.lib.maintainers.chaoflow ];
  };
}
