{ lib, stdenv
, nix-update-script
, appstream
, appstream-glib
, dbus
, desktop-file-utils
, elementary-gtk-theme
, elementary-icon-theme
, fetchFromGitHub
, fetchpatch
, flatpak
, gettext
, glib
, granite
, gtk3
, json-glib
, libgee
, libsoup
, libxml2
, meson
, ninja
, packagekit
, pantheon
, pkg-config
, python3
, vala
, polkit
, libhandy_0
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "appcenter";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "MsaXdmL+M+NYAJrrwluleeNxqQg0soFbO/G/FqibBFI=";
  };

  patches = [
    # Allow build with appstream 0.14.x
    # https://github.com/elementary/appcenter/pull/1493
    (fetchpatch {
      url = "https://github.com/elementary/appcenter/commit/5807dd13fe3c715f26225aed8d7a0abdea0c2a64.patch";
      sha256 = "BvEahG9lU9ZdgooFDFhm5evRvnKVcmcHLdmZPb85gbo=";
    })
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    appstream-glib
    dbus # for pkg-config
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    appstream
    elementary-gtk-theme
    elementary-icon-theme
    flatpak
    glib
    granite
    gtk3
    json-glib
    libgee
    libhandy_0 # doesn't support libhandy-1 yet
    libsoup
    libxml2
    packagekit
    polkit
  ];

  mesonFlags = [
    "-Dhomepage=false"
    "-Dpayments=false"
    "-Dcurated=false"
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with lib; {
    homepage = "https://github.com/elementary/appcenter";
    description = "An open, pay-what-you-want app store for indie developers, designed for elementary OS";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
