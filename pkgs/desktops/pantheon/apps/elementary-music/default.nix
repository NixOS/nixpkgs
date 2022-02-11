{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, desktop-file-utils
, meson
, ninja
, pkg-config
, python3
, vala
, wrapGAppsHook
, elementary-icon-theme
, glib
, granite
, gst_all_1
, gtk3
, libgda
, libgee
, libgpod
, libhandy
, libpeas
, taglib
, zeitgeist
}:

stdenv.mkDerivation rec {
  pname = "elementary-music";
  version = "5.1.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "music";
    rev = version;
    sha256 = "1wqsn4ss9acg0scaqpg514ll2dj3bl71wly4mm79qkinhy30yv9n";
  };

  patches = [
    # Upstream code not respecting our localedir
    # https://github.com/elementary/music/pull/648
    (fetchpatch {
      url = "https://github.com/elementary/music/commit/aea97103d59afd213467403a48788e476e47c4c3.patch";
      sha256 = "1ayj8l6lb19hhl9bhsdfbq7jgchfmpjx0qkljnld90czcksn95yx";
    })
    # Fix build with meson 0.61
    # https://github.com/elementary/music/pull/674
    (fetchpatch {
      url = "https://github.com/elementary/music/commit/fb3d840049c1e2e0bf8fdddea378a2db647dd096.patch";
      sha256 = "sha256-tQZv7hZExLqbkGXahZxDfg7bkgwCKYbDholC2zuwlNw=";
    })
  ];

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    elementary-icon-theme
    glib
    granite
    gtk3
    libgda
    libgee
    libgpod
    libhandy
    libpeas
    taglib
    zeitgeist
  ] ++ (with gst_all_1; [
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gstreamer
  ]);

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
    description = "Music player and library designed for elementary OS";
    homepage = "https://github.com/elementary/music";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.music";
  };
}
