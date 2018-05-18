{ stdenv, fetchurl, fetchpatch, pkgconfig, libxml2, xorg, glib, pango
, intltool, libgnome, libgnomecanvas, libbonoboui, GConf, libtool
, gnome_vfs, libgnome-keyring, libglade }:

stdenv.mkDerivation rec {
  name = "libgnomeui-${minVer}.5";
  minVer = "2.24";

  src = fetchurl {
    url = "mirror://gnome/sources/libgnomeui/${minVer}/${name}.tar.bz2";
    sha256 = "03rwbli76crkjl6gp422wrc9lqpl174k56cp9i96b7l8jlj2yddf";
  };

  outputs = [ "out" "dev" ];

  patches = [
    (fetchpatch {
      name = "0001-gnome-scores.h-Convert-to-UTF-8.patch";
      url = https://github.com/GNOME/libgnomeui/commit/30334c28794ef85d8973f4ed0779b5ceed6594f2.diff;
      sha256 = "1sn8j8dkam14wfkpw8nga3gk63wniff243mzv3jp0fvv52q8sqhk";
    })
  ];

  nativeBuildInputs = [ pkgconfig intltool ];
  buildInputs =
    [ xorg.xlibsWrapper libxml2 GConf pango glib libgnome-keyring libglade libtool ];

  propagatedBuildInputs = [ libgnome libbonoboui libgnomecanvas gnome_vfs ];
}
