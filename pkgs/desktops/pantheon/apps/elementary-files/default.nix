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
, elementary-dock
, bamf
, sqlite
, libdbusmenu-gtk3
, zeitgeist
, glib-networking
, elementary-icon-theme
, libcloudproviders
, libgit2-glib
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-files";
  version = "4.5.0";

  repoName = "files";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "sha256-wtQW1poX791DAlSFdVV9psnCfBDeVXI2fDZ2GcvvNn8=";
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
    elementary-dock
    elementary-icon-theme
    granite
    gtk3
    libcanberra
    libcloudproviders
    libdbusmenu-gtk3
    libgee
    libgit2-glib
    libnotify
    libunity
    pango
    sqlite
    zeitgeist
  ];

  patches = [
    ./0001-filechooser-module-hardcode-gsettings-for-nixos.patch
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
