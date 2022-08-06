{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, callPackage
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
, geocode-glib_2
, granite
, gtk3
, libchamplain
, libgee
, libhandy
, libical
, libsoup_3
}:

let
  # As evolution-data-server has been ported to libsoup_3
  # Everything has to be ported to libsoup_3.
  #
  # TODO: I really shouldn't do random overrides.
  # That's why this is a draft PR.
  geoclue2' = callPackage ./geoclue { };
  libchamplain' = libchamplain.overrideAttrs (old: {
    # https://gitlab.gnome.org/GNOME/libchamplain/-/merge_requests/13
    patches = (old.patches or [ ]) ++ [
      (fetchpatch {
        url = "https://gitlab.gnome.org/GNOME/libchamplain/-/commit/1cbaf3193c2b38e447fbc383d4c455c3dcac6db8.patch";
        sha256 = "uk38gExnUgeUKwhDsqRU77hGWhJ+8fG5dSiV2MAWLFk=";
        excludes = [ ".gitlab-ci.yml" ];
      })
    ];
    buildInputs = old.buildInputs ++ [
      libsoup_3
    ];
  });
in
stdenv.mkDerivation rec {
  pname = "elementary-calendar";
  version = "6.1.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "calendar";
    rev = version;
    sha256 = "sha256-c2c8QNifBDzb0CelB72AIL4G694l6KCSXBjWIHrzZJo=";
  };

  patches = [
    # https://github.com/elementary/calendar/pull/757
    (fetchpatch {
      url = "https://github.com/elementary/calendar/commit/1963d9529686797b7f87ea1a52ed0b269d023de1.patch";
      sha256 = "n2nj/QvkwoqGAfkfrG/1rOfsrPv3ARifRlA0dOzsTS4=";
      name = "drop-libecal-1.2-support.patch";
    })
    (fetchpatch {
      url = "https://github.com/elementary/calendar/commit/975a4f971a43e22a7f0ac78b3415f1b3eb9401ab.patch";
      sha256 = "fnMduqy2KQ1Sxg/p7Jv9CBGvmoe2j0SS6MPPrybngeo=";
      name = "libsoup-3.0-support.patch";
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
    libsoup_3
    folks
    geoclue2'
    geocode-glib_2
    granite
    gtk3
    libchamplain'
    libgee
    libhandy
    libical
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
    description = "Desktop calendar app designed for elementary OS";
    homepage = "https://github.com/elementary/calendar";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.calendar";
  };
}
