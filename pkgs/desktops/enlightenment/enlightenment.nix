{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, efl,
  xcbutilkeysyms, libXrandr, libXdmcp, libxcb, libffi, pam, alsaLib,
  luajit, bzip2, libpthreadstubs, gdbm, libcap, mesa_glu,
  xkeyboard_config, pcre
}:

stdenv.mkDerivation rec {
  name = "enlightenment-${version}";
  version = "0.22.1";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/enlightenment/${name}.tar.xz";
    sha256 = "1q57fz57d0b26z06m1wiq7c1sniwh885b0vs02mk4jgwva46nyr0";
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
  ] ++
    stdenv.lib.optionals stdenv.isLinux [ libcap ];

  # Instead of setting owner to root and permissions to setuid/setgid
  # (which is not allowed for files in /nix/store) of some
  # enlightenment programs, the file $out/e-wrappers.nix is created,
  # containing the needed configuration for that purpose. It can be
  # used in the enlightenment module.
  patches = [ ./enlightenment.suid-exes.patch ];

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
