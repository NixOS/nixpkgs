{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, substituteAll
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
, elementary-settings-daemon
, gettext
, libhandy
, wrapGAppsHook
, appcenter
}:

stdenv.mkDerivation rec {
  pname = "elementary-onboarding";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "onboarding";
    rev = version;
    sha256 = "sha256-9voy9eje3VlV4IMM664EyjKWTfSVogX5JoRCqhsUXTE=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      appcenter = appcenter;
    })
    # Provides the directory where the locales are actually installed
    # https://github.com/elementary/onboarding/pull/147
    (fetchpatch {
      url = "https://github.com/elementary/onboarding/commit/af19c3dbefd1c0e0ec18eddacc1f21cb991f5513.patch";
      sha256 = "sha256-fSFfjSd33W7rXXEUHY8b3rv9B9c31XfCjxjRxBBrqjs=";
    })
  ];

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
    elementary-icon-theme
    elementary-settings-daemon # settings schema
    glib
    granite
    gtk3
    libgee
    libhandy
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
    description = "Onboarding app for new users designed for elementary OS";
    homepage = "https://github.com/elementary/onboarding";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.onboarding";
  };
}
