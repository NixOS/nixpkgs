{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, wrapQtAppsHook
, qtbase
, dtkcore
, gsettings-qt
, libsecret
, xorg
, systemd
, dde-polkit-agent
}:

stdenv.mkDerivation rec {
  pname = "dde-session";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-CyHvvNALXe4fOMjD48By/iaU6/xNUhH9yG19Ob3bHy0=";
  };

  postPatch = ''
    # Avoid using absolute path to distinguish applications
    substituteInPlace src/dde-session/impl/sessionmanager.cpp \
      --replace 'file.readAll().startsWith("/usr/bin/dde-lock")' 'file.readAll().contains("dde-lock")' \

    substituteInPlace systemd/dde-session-initialized.target.wants/dde-polkit-agent.service \
      --replace "/usr/lib/polkit-1-dde" "${dde-polkit-agent}/lib/polkit-1-dde"

    for file in $(grep -rl "/usr/lib/deepin-daemon"); do
      substituteInPlace $file --replace "/usr/lib/deepin-daemon" "/run/current-system/sw/lib/deepin-daemon"
    done

    for file in $(grep -rl "/usr/bin"); do
      substituteInPlace $file --replace "/usr/bin/" "/run/current-system/sw/bin/"
    done
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    dtkcore
    gsettings-qt
    libsecret
    xorg.libXcursor
    systemd
  ];

  # FIXME: dde-wayland always exits abnormally
  passthru.providedSessions = [ "dde-x11" ];

  meta = with lib; {
    description = "New deepin session based on systemd and existing projects";
    homepage = "https://github.com/linuxdeepin/dde-session";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
