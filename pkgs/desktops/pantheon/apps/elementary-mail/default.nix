{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, pkg-config
, meson
, ninja
, python3
, vala
, gtk3
, libxml2
, libhandy
, webkitgtk_4_1
, folks
, glib-networking
, granite
, evolution-data-server
, wrapGAppsHook
, libgee
}:

stdenv.mkDerivation rec {
  pname = "elementary-mail";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "mail";
    rev = version;
    sha256 = "sha256-DO3nybH7tb/ISrSQ3+Oj612m64Ov6X0GAWePMbKjCc4=";
  };

  patches = [
    # build: fix documentation build
    # https://github.com/elementary/mail/pull/795
    (fetchpatch {
      url = "https://github.com/elementary/mail/commit/52a422cb1c5f061d8a683005e44da0a1c2195096.patch";
      sha256 = "sha256-ndcIZXvmQbM/31Wtm6OSCnXdMYx+OlJrqV+baq6m+KY=";
    })
    # build: support webkit2gtk-4.1
    # https://github.com/elementary/mail/pull/794
    (fetchpatch {
      url = "https://github.com/elementary/mail/commit/9e6eb73a8420c9bf327e59c25e7e6d8fa87d480a.patch";
      sha256 = "sha256-idkVymePLa7vgfuou0HIrbWRCaWAgZliDcp4HyZBArs=";
    })
  ];

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    evolution-data-server
    folks
    glib-networking
    granite
    gtk3
    libgee
    libhandy
    webkitgtk_4_1
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Mail app designed for elementary OS";
    homepage = "https://github.com/elementary/mail";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ethancedwards8 ] ++ teams.pantheon.members;
    mainProgram = "io.elementary.mail";
  };
}
