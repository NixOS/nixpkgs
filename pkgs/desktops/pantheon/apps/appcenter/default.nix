{ lib
, stdenv
, nix-update-script
, appstream
, appstream-glib
, dbus
, desktop-file-utils
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
, libhandy
, libsoup
, libxml2
, meson
, ninja
, packagekit
, pkg-config
, python3
, vala
, polkit
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "appcenter";
  version = "3.9.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-xktIHQHmz5gh72NEz9UQ9fMvBlj1BihWxHgxsHmTIB0=";
  };

  patches = [
    # Fix AppStream.PoolFlags being renamed
    # Though the API break has been fixed in latest appstream,
    # let's use the non-deprecated version anyway.
    # https://github.com/elementary/appcenter/pull/1794
    (fetchpatch {
      url = "https://github.com/elementary/appcenter/commit/84bc6400713484aa9365f0ba73f59c495da3f08b.patch";
      sha256 = "sha256-HNRCJ/5mRbEVjCq9nrXtdQOOk1Jj5jalApkghD8ecpk=";
    })
  ];

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
    elementary-icon-theme
    flatpak
    glib
    granite
    gtk3
    json-glib
    libgee
    libhandy
    libsoup
    libxml2
    packagekit
    polkit
  ];

  mesonFlags = [
    "-Dpayments=false"
    "-Dcurated=false"
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/elementary/appcenter";
    description = "An open, pay-what-you-want app store for indie developers, designed for elementary OS";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.appcenter";
  };
}
