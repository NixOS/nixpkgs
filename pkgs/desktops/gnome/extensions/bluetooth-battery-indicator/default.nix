{ stdenv
, lib
, fetchFromGitHub
, substituteAll
, glib
, python3
, bluetooth_battery
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-bluetooth-battery-indicator";
  version = "unstable-2021-08-13";

  src = fetchFromGitHub {
    owner = "MichalW";
    repo = "gnome-bluetooth-battery-indicator";
    rev = "3b5e6b93e251058a99e3f258bceb2723166c085b";
    sha256 = "ZHM3OAqXLKoh2IUXEtfBht8rfOgg259sXNelbmYTPSw=";
  };

  patches = [
    # Make dependencies available at runtime.
    (substituteAll {
      src = ./fix-paths.patch;
      bluetooth_battery = "${bluetooth_battery}/bin/bluetooth_battery";
      python = python3.interpreter;
    })
  ];

  nativeBuildInputs = [
    glib
  ];

  buildPhase = ''
    runHook preBuild

    glib-compile-schemas --strict --targetdir=schemas schemas

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/gnome-shell/extensions/${passthru.extensionUuid}"
    cp -r *.js *.json schemas/ "$out/share/gnome-shell/extensions/${passthru.extensionUuid}"

    runHook postInstall
  '';

  passthru = {
    extensionUuid = "bluetooth-battery@michalw.github.com";
    extensionPortalSlug = "bluetooth-battery";

    updateScript = unstableGitUpdater {
      # The updater tries src.url by default, which does not exist for fetchFromGitHub (fetchurl).
      url = "${src.meta.homepage}.git";
    };
  };

  meta = with lib; {
    description = "GNOME Shell extension displaying battery percentage for bluetooth devices";
    homepage = "https://github.com/MichalW/gnome-bluetooth-battery-indicator";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      jtojnar
    ];
    platforms = platforms.linux;
  };
}
