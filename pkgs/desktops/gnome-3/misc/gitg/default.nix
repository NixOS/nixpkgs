{ stdenv, fetchurl, fetchpatch, vala, intltool, pkgconfig, gtk3, glib
, json-glib, wrapGAppsHook, libpeas, bash, gobject-introspection
, gnome3, gtkspell3, shared-mime-info, libgee, libgit2-glib, libsecret
, meson, ninja, python3
 }:

let
  pname = "gitg";
  version = "3.30.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1fz8q1aiql6k740savdjh0vzbyhcflgf94cfdhvzcrrvm929n2ss";
  };

  patches = [
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/gitg/commit/42bceea265f53fe7fd4a41037b936deed975fc6c.patch;
      sha256 = "1xq245rsi1bi66lswk33pdiazfaagxf77836ds5q73900rx4r7fw";
    })
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
    sed -i '/gtk-update-icon-cache/s/^/#/' meson_post_install.py

    substituteInPlace tests/libgitg/test-commit.vala --replace "/bin/bash" "${bash}/bin/bash"
  '';

  doCheck = true;

  enableParallelBuilding = true;

  buildInputs = [
    gtk3 glib json-glib libgee libpeas gnome3.libsoup
    libgit2-glib gtkspell3 gnome3.gtksourceview gnome3.gsettings-desktop-schemas
    libsecret gobject-introspection gnome3.adwaita-icon-theme
  ];

  nativeBuildInputs = [ meson ninja python3 vala wrapGAppsHook intltool pkgconfig ];

  preFixup = ''
    gappsWrapperArgs+=(
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Gitg;
    description = "GNOME GUI client to view git repositories";
    maintainers = with maintainers; [ domenkozar ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
