{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, alsaLib, bc,
  bzip2, efl, gdbm, libXdmcp, libXrandr, libcap, libffi,
  libpthreadstubs, libxcb, luajit, mesa, pam, pcre, xcbutilkeysyms,
  xkeyboard_config,

  bluetoothSupport ? true, bluez5,
  pulseSupport ? !stdenv.isDarwin, libpulseaudio,
}:

stdenv.mkDerivation rec {
  pname = "enlightenment";
  version = "0.23.1";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "0d1cyl07w9pvi2pf029kablazks2q9aislzl46b6fq5m1465jc75";
  };

  nativeBuildInputs = [
    (pkgconfig.override { vanilla = true; })
    gettext
    meson
    ninja
  ];

  buildInputs = [
    alsaLib
    bc  # for the Everything module calculator mode
    bzip2
    efl
    gdbm
    libXdmcp
    libXrandr
    libffi
    libpthreadstubs
    libxcb
    luajit
    mesa
    pam
    pcre
    xcbutilkeysyms
    xkeyboard_config
  ]
  ++ stdenv.lib.optional stdenv.isLinux libcap
  ++ stdenv.lib.optional bluetoothSupport bluez5
  ++ stdenv.lib.optional pulseSupport libpulseaudio
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
    # edge_cc is a binary provided by efl and cannot be found at the directory
    # given by e_prefix_bin_get(), which is $out/bin

    substituteInPlace src/bin/e_import_config_dialog.c \
      --replace "e_prefix_bin_get()" "\"${efl}/bin\""

    substituteInPlace src/modules/everything/evry_plug_calc.c \
      --replace "ecore_exe_pipe_run(\"bc -l\"" "ecore_exe_pipe_run(\"${bc}/bin/bc -l\""
  '';

  mesonFlags = [ "-Dsystemdunitdir=lib/systemd/user" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "The Compositing Window Manager and Desktop Shell";
    homepage = https://www.enlightenment.org;
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ matejc tstrobel ftrvxmtrx romildo ];
  };
}
