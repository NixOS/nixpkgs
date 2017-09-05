{ stdenv, fetchurl, intltool, gobjectIntrospection, pkgconfig }:

stdenv.mkDerivation rec {
  name = "gcab-${version}";
  version = "0.7";

  src = fetchurl {
    url = "mirror://gnome/sources/gcab/${version}/${name}.tar.xz";
    sha256 = "1vxdsiky3492zlyrym02sdwf09y19rl2z5h5iin7qm0wizw5wvm1";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool gobjectIntrospection ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };

}
