{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, meson
, ninja
, pkg-config
, python3
, vala
, wrapGAppsHook
, clutter
, evolution-data-server
, folks
, geoclue2
, geocode-glib_2
, granite
, gtk3
, libchamplain_libsoup3
, libgee
, libhandy
, libical
}:

stdenv.mkDerivation rec {
  pname = "elementary-calendar";
  version = "6.1.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "calendar";
    rev = version;
    sha256 = "sha256-psUVgl/7pmmf+8dP8ghBx5C1u4UT9ncXuVYvDJOYeOI=";
  };

  patches = [
    # build: support evolution-data-server 3.46
    # https://github.com/elementary/calendar/pull/758
    (fetchpatch {
      url = "https://github.com/elementary/calendar/commit/62c20e5786accd68b96c423b04e32c043e726cac.patch";
      sha256 = "sha256-xatxoSwAIHiUA03vvBdM8HSW27vhPLvAxEuGK0gLiio=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    clutter
    evolution-data-server
    folks
    geoclue2
    geocode-glib_2
    granite
    gtk3
    libchamplain_libsoup3
    libgee
    libhandy
    libical
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Desktop calendar app designed for elementary OS";
    homepage = "https://github.com/elementary/calendar";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.calendar";
  };
}
