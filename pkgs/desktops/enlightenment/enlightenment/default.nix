{ stdenv
, fetchurl
, meson
, ninja
, pkg-config
, gettext
, alsaLib
, acpid
, bc
, ddcutil
, efl
, pam
, xkeyboard_config
, udisks2

, bluetoothSupport ? true, bluez5
, pulseSupport ? !stdenv.isDarwin, libpulseaudio
}:

stdenv.mkDerivation rec {
  pname = "enlightenment";
  version = "0.24.2";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1wfz0rwwsx7c1mkswn4hc9xw1i6bsdirhxiycf7ha2vcipqy465y";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    alsaLib
    acpid # for systems with ACPI for lid events, AC/Battery plug in/out etc
    bc # for the Everything module calculator mode
    ddcutil # specifically libddcutil.so.2 for backlight control
    efl
    pam
    xkeyboard_config
    udisks2 # for removable storage mounting/unmounting
  ]
  ++ stdenv.lib.optional bluetoothSupport bluez5 # for bluetooth configuration and control
  ++ stdenv.lib.optional pulseSupport libpulseaudio # for proper audio device control and redirection
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
  ];

  passthru.providedSessions = [ "enlightenment" ];

  meta = with stdenv.lib; {
    description = "The Compositing Window Manager and Desktop Shell";
    homepage = "https://www.enlightenment.org";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ matejc tstrobel ftrvxmtrx romildo ];
  };
}
