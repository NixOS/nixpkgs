{ lib
, stdenv
, fetchurl
, meson
, ninja
, pkg-config
, gettext
, alsa-lib
, acpid
, bc
, ddcutil
, efl
, libexif
, pam
, xkeyboard_config
, udisks2
, waylandSupport ? false, wayland-protocols, xwayland
, bluetoothSupport ? true, bluez5
, pulseSupport ? !stdenv.isDarwin, libpulseaudio
, directoryListingUpdater
}:

stdenv.mkDerivation rec {
  pname = "enlightenment";
  version = "0.25.4";

  src = fetchurl {
    url = "https://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-VttdIGuCG5qIMdJucT5BCscLIlWm9D/N98Ae794jt6I=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    acpid # for systems with ACPI for lid events, AC/Battery plug in/out etc
    bc # for the Everything module calculator mode
    ddcutil # specifically libddcutil.so.2 for backlight control
    efl
    libexif
    pam
    xkeyboard_config
    udisks2 # for removable storage mounting/unmounting
  ]
  ++ lib.optional bluetoothSupport bluez5 # for bluetooth configuration and control
  ++ lib.optional pulseSupport libpulseaudio # for proper audio device control and redirection
  ++ lib.optionals waylandSupport [ wayland-protocols xwayland ]
  ;

  patches = [
    # Executables cannot be made setuid in nix store. They should be
    # wrapped in the enlightenment service module, and the wrapped
    # executables should be used instead.
    ./0001-wrapped-setuid-executables.patch
    ./0003-setuid-missing-path.patch
  ];

  postPatch = ''
    substituteInPlace src/modules/everything/evry_plug_calc.c \
      --replace "ecore_exe_pipe_run(\"bc -l\"" "ecore_exe_pipe_run(\"${bc}/bin/bc -l\""
  '';

  mesonFlags = [
    "-D systemdunitdir=lib/systemd/user"
  ] ++ lib.optional waylandSupport "-Dwl=true";

  passthru.providedSessions = [ "enlightenment" ];

  passthru.updateScript = directoryListingUpdater { };

  meta = with lib; {
    description = "The Compositing Window Manager and Desktop Shell";
    homepage = "https://www.enlightenment.org";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ matejc ftrvxmtrx ] ++ teams.enlightenment.members;
  };
}
