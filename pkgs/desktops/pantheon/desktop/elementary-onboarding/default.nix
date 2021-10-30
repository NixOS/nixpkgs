{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, substituteAll
, pantheon
, pkg-config
, meson
, ninja
, vala
, python3
, gtk3
, glib
, granite
, libgee
, elementary-icon-theme
, elementary-gtk-theme
, gettext
, libhandy
, wrapGAppsHook
, appcenter
}:

stdenv.mkDerivation rec {
  pname = "elementary-onboarding";
  version = "6.0.0";

  repoName = "onboarding";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "1mpw0j8ymb41py9v9qlk4nwy1lnwj7k388c7gqdv34ynck0ymfi4";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    elementary-gtk-theme
    elementary-icon-theme
    glib
    granite
    gtk3
    libgee
    libhandy
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      appcenter = appcenter;
    })
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with lib; {
    description = "Onboarding app for new users designed for elementary OS";
    homepage = "https://github.com/elementary/onboarding";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.onboarding";
  };
}
