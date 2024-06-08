{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, meson
, ninja
, pkg-config
, vala
, desktop-file-utils
, gtk3
, libexif
, libgee
, libhandy
, geocode-glib_2
, gexiv2
, libgphoto2
, granite
, gst_all_1
, libgudev
, libraw
, sqlite
, python3
, libwebp
, appstream
, wrapGAppsHook3
}:

stdenv.mkDerivation rec {
  pname = "elementary-photos";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "photos";
    rev = version;
    sha256 = "sha256-VhJggQMy1vk21zNA5pR4uAPGCwnIxLUHVO58AZs+h6s=";
  };

  patches = [
    # The following 5 patches allow building this without webkit2gtk-4.0.
    # https://github.com/elementary/photos/pull/743, https://github.com/elementary/photos/pull/746
    (fetchpatch {
      url = "https://github.com/elementary/photos/commit/c48f49869bbf44aa37e64c0c1e25aff887783a02.patch";
      hash = "sha256-CeKRONVevJqVEIchgxyPqnM16Y2zUJ1+wnL2jLdJqec=";
    })
    (fetchpatch {
      url = "https://github.com/elementary/photos/commit/d7a8265ecb562e439d003b61b0823de8348fb10d.patch";
      hash = "sha256-6M3t0l8BUhoaowUSfaiz6xjQBHliO13i+qi5cgfEY04=";
    })
    (fetchpatch {
      url = "https://github.com/elementary/photos/commit/d8e13e8e803ed7ab1bd23527866567d998744f57.patch";
      hash = "sha256-BGBDIHR5iYtd+rJG9sur1oWa4FK/lF0vLdjyPbyNbdU=";
    })
    (fetchpatch {
      url = "https://github.com/elementary/photos/commit/075f983a65e9c6d4e80ee07f0c05309badef526a.patch";
      excludes = [ ".github/workflows/ci.yml" ];
      hash = "sha256-QOtssVwwHxFdtfhcVyaN33LMZdOkg/DoAC+UAbrkmDk=";
    })
    (fetchpatch {
      url = "https://github.com/elementary/photos/commit/ea11cf23db6945df6cc3495fd698456054389371.patch";
      hash = "sha256-4a/CRx7Dmyyda6SUr0QF++R73v7FBzjXfyxvspynnG0=";
    })
  ];

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    geocode-glib_2
    gexiv2
    granite
    gtk3
    libexif
    libgee
    libgphoto2
    libgudev
    libhandy
    libraw
    libwebp
    sqlite
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
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Photo viewer and organizer designed for elementary OS";
    homepage = "https://github.com/elementary/photos";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.photos";
  };
}
