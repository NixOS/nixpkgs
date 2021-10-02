{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, pkg-config
, meson
, ninja
, vala
, gtk3
, libgee
, granite
, polkit
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "pantheon-agent-polkit";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1acqjjarl225yk0f68wkldsamcrzrj0ibpcxma04wq9w7jlmz60c";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    granite
    gtk3
    libgee
    polkit
  ];

  meta = with lib; {
    description = "Polkit Agent for the Pantheon Desktop";
    homepage = "https://github.com/elementary/pantheon-agent-polkit";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
