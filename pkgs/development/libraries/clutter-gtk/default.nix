{ fetchurl, lib, stdenv, pkg-config, meson, ninja
, gobject-introspection, clutter, gtk3, gnome3 }:

let
  pname = "clutter-gtk";
  version = "1.8.4";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "01ibniy4ich0fgpam53q252idm7f4fn5xg5qvizcfww90gn9652j";
  };

  outputs = [ "out" "dev" ];

  propagatedBuildInputs = [ clutter gtk3 ];
  nativeBuildInputs = [ meson ninja pkg-config gobject-introspection ];

  postBuild = "rm -rf $out/share/gtk-doc";

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = {
    description = "Clutter-GTK";
    homepage = "http://www.clutter-project.org/";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ lethalman ];
    platforms = lib.platforms.gnu ++ lib.platforms.linux;  # arbitrary choice
  };
}
