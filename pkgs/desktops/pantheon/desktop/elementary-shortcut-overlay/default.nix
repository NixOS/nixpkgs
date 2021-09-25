{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, pantheon
, pkg-config
, meson
, ninja
, vala
, libxml2
, desktop-file-utils
, gtk3
, glib
, granite
, libgee
, libhandy
, elementary-icon-theme
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-shortcut-overlay";
  version = "1.2.0";

  repoName = "shortcut-overlay";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "1zs2fpx4agr00rsfmpi00nhiw92mlypzm4p9x3g851p24m62fn79";
  };

  patches = [
    # Upstream code not respecting our localedir
    # https://github.com/elementary/shortcut-overlay/pull/100
    (fetchpatch {
      url = "https://github.com/elementary/shortcut-overlay/commit/f26e3684568e30cb6e151438e2d86c4d392626bf.patch";
      sha256 = "0zxyqpk9xbxdm8lmgdwbb4yzzwbjlhypsca3xs34a2pl0b9pcdwd";
    })
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils
    libxml2
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    elementary-icon-theme
    glib
    granite
    gtk3
    libgee
    libhandy
  ];

  meta = with lib; {
    description = "A native OS-wide shortcut overlay to be launched by Gala";
    homepage = "https://github.com/elementary/shortcut-overlay";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
