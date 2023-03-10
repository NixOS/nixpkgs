{ fetchurl
, lib
, stdenv
, pkg-config
, meson
, ninja
, gobject-introspection
, clutter
, gtk3
, gnome
}:

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

  postPatch = ''
    # ld: malformed 32-bit x.y.z version number: =1
    substituteInPlace meson.build \
      --replace "host_system == 'darwin'" "false"
  '';

  postBuild = "rm -rf $out/share/gtk-doc";

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    description = "Clutter-GTK";
    homepage = "http://www.clutter-project.org/";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;
  };
}
