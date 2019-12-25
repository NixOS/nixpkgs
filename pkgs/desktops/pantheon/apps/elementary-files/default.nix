{ stdenv
, fetchFromGitHub
, pantheon
, pkgconfig
, meson
, ninja
, gettext
, vala
, python3
, desktop-file-utils
, libcanberra
, gtk3
, glib
, libgee
, granite
, libnotify
, libunity
, pango
, plank
, bamf
, sqlite
, libdbusmenu-gtk3
, zeitgeist
, glib-networking
, elementary-icon-theme
, libcloudproviders
, fetchpatch
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-files";
  version = "4.2.0";

  repoName = "files";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "12f0hzb62nchksyqd2gwj3cv001rph24ggd9wywh9i1qwppx4b5k";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    glib-networking
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    bamf
    elementary-icon-theme
    granite
    gtk3
    libcanberra
    libcloudproviders
    libdbusmenu-gtk3
    libgee
    libnotify
    libunity
    pango
    plank
    sqlite
    zeitgeist
  ];

  patches = [
    ./hardcode-gsettings.patch
    # Fixes https://github.com/elementary/files/issues/1081
    (fetchpatch {
      url = "https://github.com/elementary/files/commit/76b5cc95466733c2c100a99127ecd4fbd4d2a5ec.patch";
      sha256 = "0dn8a9l7i2rdgia1rsc50332fsw0yrbfvpb5z8ba4iiki3lxy2nn";
    })
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py

    substituteInPlace filechooser-module/FileChooserDialog.vala \
      --subst-var-by ELEMENTARY_FILES_GSETTINGS_PATH ${glib.makeSchemaPath "$out" "${pname}-${version}"}
  '';

  meta = with stdenv.lib; {
    description = "File browser designed for elementary OS";
    homepage = https://github.com/elementary/files;
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
