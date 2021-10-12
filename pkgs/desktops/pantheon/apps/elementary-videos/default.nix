{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, pantheon
, pkg-config
, meson
, ninja
, vala
, python3
, desktop-file-utils
, gtk3
, granite
, libgee
, clutter-gst
, clutter-gtk
, gst_all_1
, elementary-icon-theme
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-videos";
  version = "2.7.3";

  repoName = "videos";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "04nl9kn33dysvsg0n5qx1z8qgrifkgfwsm7gh1l308v3n8c69lh7";
  };

  patches = [
    # Upstream code not respecting our localedir
    # https://github.com/elementary/videos/pull/233
    (fetchpatch {
      url = "https://github.com/elementary/videos/commit/19ba2a9148be09ea521d2e9ac29dede6b9c6fa07.patch";
      sha256 = "0ffp7ana98846xi7vxrzfg6dbs4yy28x2i4ky85mqs1gj6fjqin5";
    })
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = with gst_all_1; [
    clutter-gst
    clutter-gtk
    elementary-icon-theme
    granite
    gst-libav
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gstreamer
    gtk3
    libgee
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with lib; {
    description = "Video player and library app designed for elementary OS";
    homepage = "https://github.com/elementary/videos";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
