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
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-files";
  version = "4.1.9";

  repoName = "files";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "12p1li9a7kqdlgkq20svaly5kr661ww93qngaiic6zv1bdw2bpmv";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      inherit repoName;
      attrPath = pname;
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
    libdbusmenu-gtk3
    libgee
    libnotify
    libunity
    pango
    plank
    sqlite
    zeitgeist
  ];

  patches = [ ./hardcode-gsettings.patch ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py

    substituteInPlace filechooser-module/FileChooserDialog.vala \
      --subst-var-by ELEMENTARY_FILES_GSETTINGS_PATH $out/share/gsettings-schemas/${pname}-${version}/glib-2.0/schemas
  '';

  meta = with stdenv.lib; {
    description = "File browser designed for elementary OS";
    homepage = https://github.com/elementary/files;
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
