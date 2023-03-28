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
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "mail";
    rev = version;
    sha256 = "sha256-IY+ml/ftLSk0A3Emi0ZL2wxIDIngNU6QKbHErRAaaMA=";
  };

  patches = [
    # MessageListItem: avoid crashing on empty Mime
    # https://github.com/elementary/mail/pull/828
    (fetchpatch {
      url = "https://github.com/elementary/mail/commit/7cb412dee4cc8c0bfab55057c47d5ecce6918788.patch";
      sha256 = "sha256-7rYvgFeVmV/rVYzC/xt/lioRlveM0d8ORqZdMYkm/d4=";
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
