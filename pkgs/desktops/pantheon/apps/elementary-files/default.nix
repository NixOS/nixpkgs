{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, pkg-config
, meson
, ninja
, vala
, desktop-file-utils
, libcanberra
, gtk3
, glib
, libgee
, libhandy
, granite
, libnotify
, pango
, elementary-dock
, bamf
, sqlite
, zeitgeist
, libcloudproviders
, libgit2-glib
, wrapGAppsHook
, systemd
}:

stdenv.mkDerivation rec {
  pname = "elementary-files";
  version = "6.5.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "files";
    rev = version;
    sha256 = "sha256-E1e2eXGpycl2VXEUvUir5G3MRLz/4TQMvmOuWgU9JNc=";
  };

  patches = [
    # meson: Don't run gtk-update-icon-cache
    # https://github.com/elementary/files/pull/2294
    (fetchpatch {
      url = "https://github.com/elementary/files/commit/758ece9fb29eb4a25f47065710dad4ac547ca2ce.patch";
      hash = "sha256-+OASDsOPH0g5Cyxw4JmVxA70zQHhcpqLMKKYP4VLTO0=";
    })
  ];

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    bamf
    elementary-dock
    glib
    granite
    gtk3
    libcanberra
    libcloudproviders
    libgee
    libgit2-glib
    libhandy
    libnotify
    pango
    sqlite
    systemd
    zeitgeist
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "File browser designed for elementary OS";
    homepage = "https://github.com/elementary/files";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.files";
  };
}
