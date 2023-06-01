{ stdenv
, lib
, fetchurl
, fetchpatch2
, meson
, ninja
, pkg-config
, libxml2
, gnome
, gtk4
, gettext
, libadwaita
, itstool
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "zenity";
  version = "3.92.0";

  src = fetchurl {
    url = "mirror://gnome/sources/zenity/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "bSvCP2bL2PfhlVVvDDG9ZfClx4vLGuow6XFty/qxqKk=";
  };

  patches = [
    # Add non-fatal deprecation warning for --attach, --icon-name, --hint
    # To reduce issues like https://github.com/BuddiesOfBudgie/budgie-desktop/issues/356
    (fetchpatch2 {
      url = "https://gitlab.gnome.org/GNOME/zenity/-/commit/181ca36ad4790b425f79b20be40dd25804208463.patch";
      sha256 = "Z6XOn5XnBzJSti8tD4EGezCpHmYAsIxBf7s4W3rBc9I=";
    })
    (fetchpatch2 {
      url = "https://gitlab.gnome.org/GNOME/zenity/-/commit/70abb01173562dba40916c522bd20b4ba5a55904.patch";
      sha256 = "yBm7AxJiTPh2BFb+79L4WSh8xOcM6AHuvLzIEEFY80s=";
    })
    (fetchpatch2 {
      url = "https://gitlab.gnome.org/GNOME/zenity/-/commit/df445feb0c0fab6865d96fb693a32fbc26503d83.patch";
      sha256 = "DTeBCsahceNZCfNziO2taXiMEdAFgm5Bx9OrlZv0LsM=";
    })
    (fetchpatch2 {
      url = "https://gitlab.gnome.org/GNOME/zenity/-/commit/54bd43cbe30fbe5c9f01e42e8f3de63405770e2a.patch";
      sha256 = "tR9CKt24w7D3EA6FLu6qroS5rTkfIsaQnuY4KzgDKMY=";
    })

    # Restore the availability of running multiple instances of zenity
    # https://gitlab.gnome.org/GNOME/zenity/-/issues/58
    (fetchpatch2 {
      url = "https://gitlab.gnome.org/GNOME/zenity/-/commit/cd32ad7d3fa66dccc77d96a0fd3a61bf137250f6.patch";
      sha256 = "4XCuJgXsNIiBXv4NM1JRoiqgBqyxnro0HHapkK2fM8o=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    itstool
    libxml2
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "zenity";
      attrPath = "gnome.zenity";
    };
  };

  meta = with lib; {
    description = "Tool to display dialogs from the commandline and shell scripts";
    homepage = "https://wiki.gnome.org/Projects/Zenity";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
}
