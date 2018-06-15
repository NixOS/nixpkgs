{ stdenv, fetchurl, pkgconfig, intltool, gnome3 }:
let
  pname = "gnome-video-effects";
  version = "0.4.3";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "06c2f1kihyhawap1s3zg5w7q7fypsybkp7xry4hxkdz4mpsy0zjs";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "A collection of GStreamer effects to be used in different GNOME Modules";
    homepage = https://wiki.gnome.org/Projects/GnomeVideoEffects;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
  };
}
