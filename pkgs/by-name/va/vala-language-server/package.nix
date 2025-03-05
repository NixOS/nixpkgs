{ stdenv
, lib
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, scdoc
, gnome-builder
, glib
, libgee
, json-glib
, jsonrpc-glib
, vala
}:

stdenv.mkDerivation rec {
  pname = "vala-language-server";
  version = "0.48.7";

  src = fetchFromGitHub {
    owner = "vala-lang";
    repo = pname;
    rev = version;
    sha256 = "sha256-Vl5DjKBdpk03aPD+0xGoTwD9Slg1rREorqZGX5o10cY=";
  };

  passthru = {
    updateScript = nix-update-script { };
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    # GNOME Builder Plugin
    gnome-builder
  ];

  buildInputs = [
    glib
    libgee
    json-glib
    jsonrpc-glib
    vala
  ];

  meta = with lib; {
    description = "Code Intelligence for Vala & Genie";
    mainProgram = "vala-language-server";
    homepage = "https://github.com/vala-lang/vala-language-server";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ andreasfelix ];
    platforms = platforms.unix;
  };
}
