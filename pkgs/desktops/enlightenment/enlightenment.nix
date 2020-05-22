{ stdenv
, fetchurl
, meson
, ninja
, pkgconfig
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
  version = "0.24.0";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "01053hxdmyjfb6gmz1pqmw0llrgc4356np515h5vsqcn59mhvfz7";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkgconfig
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
    # Some programs installed by enlightenment (to set the cpu frequency,
    # for instance) need root ownership and setuid/setgid permissions, which
    # are not allowed for files in /nix/store. Instead of allowing the
    # installer to try to do this, the file $out/e-wrappers.nix is created,
    # containing the needed configuration for wrapping those programs. It
    # can be used in the enlightenment module. The idea is:
    #
    #  1) rename the original binary adding the extension .orig
    #  2) wrap the renamed binary at /run/wrappers/bin/
    #  3) create a new symbolic link using the original binary name (in the
    #     original directory where enlightenment wants it) pointing to the
    #     wrapper

    ./enlightenment.suid-exes.patch
  ];

  postPatch = ''
    substituteInPlace src/modules/everything/evry_plug_calc.c \
      --replace "ecore_exe_pipe_run(\"bc -l\"" "ecore_exe_pipe_run(\"${bc}/bin/bc -l\""
  '';

  mesonFlags = [
    "-D systemdunitdir=lib/systemd/user"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "The Compositing Window Manager and Desktop Shell";
    homepage = "https://www.enlightenment.org";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ matejc tstrobel ftrvxmtrx romildo ];
  };
}
