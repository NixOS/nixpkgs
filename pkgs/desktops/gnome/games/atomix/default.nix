{ lib, stdenv, fetchurl, fetchpatch
, meson, ninja, pkg-config, wrapGAppsHook, python3
, gettext, gnome, glib, gtk3, libgnome-games-support, gdk-pixbuf }:

stdenv.mkDerivation rec {
  pname = "atomix";
  version = "3.34.0";

  src = fetchurl {
    url = "mirror://gnome/sources/atomix/${lib.versions.majorMinor version}/atomix-${version}.tar.xz";
    sha256 = "0h909a4mccf160hi0aimyicqhq2b0gk1dmqp7qwf87qghfrw6m00";
  };

  patches = [
    # Pull upstream fix for -fno-common toolchains like gcc-10:
    #  https://gitlab.gnome.org/GNOME/atomix/-/merge_requests/2
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://gitlab.gnome.org/GNOME/atomix/-/commit/be7f44f1945a569494d46c60eaf6e7b39b2bb48b.patch";
      sha256 = "0nrwl6kb1als9mxd5s0la45z63xwshqlnxqjaax32w8yrl6kz7l8";
    })
  ];

  nativeBuildInputs = [ meson ninja pkg-config gettext wrapGAppsHook python3 ];
  buildInputs = [ glib gtk3 gdk-pixbuf libgnome-games-support gnome.adwaita-icon-theme ];

  # When building with clang ceil() is not inlined:
  # ld: src/libatomix.a.p/canvas_helper.c.o: undefined reference to symbol 'ceil@@GLIBC_2.2.5'
  #  https://gitlab.gnome.org/GNOME/atomix/-/merge_requests/3
  NIX_LDFLAGS = "-lm";

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    description = "Puzzle game where you move atoms to build a molecule";
    homepage = "https://wiki.gnome.org/Apps/Atomix";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
