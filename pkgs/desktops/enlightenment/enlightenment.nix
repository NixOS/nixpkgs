{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, efl,
  xcbutilkeysyms, libXrandr, libXdmcp, libxcb, libffi, pam, alsaLib,
  luajit, bzip2, libpthreadstubs, gdbm, libcap, mesa,
  xkeyboard_config, pcre,

  bluetoothSupport ? true, bluez5,
  pulseSupport ? !stdenv.isDarwin, libpulseaudio,
}:

stdenv.mkDerivation rec {
  pname = "enlightenment";
  version = "0.23.0";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1y7x594gvyvl5zbb1rnf3clj2pm6j97n8wl5mp9x6xjmhx0d1idq";
  };

  nativeBuildInputs = [
    meson
    ninja
    (pkgconfig.override { vanilla = true; })
    gettext
  ];

  buildInputs = [
    efl
    libXdmcp
    libxcb
    xcbutilkeysyms
    libXrandr
    libffi
    pam
    alsaLib
    luajit
    bzip2
    libpthreadstubs
    gdbm
    pcre
    mesa
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
