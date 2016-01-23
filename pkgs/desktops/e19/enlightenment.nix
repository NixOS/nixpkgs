{ stdenv, fetchurl, pkgconfig, e19, xorg, libffi, pam, alsaLib, luajit, bzip2, libuuid
, libpthreadstubs, gdbm, libcap, mesa_glu, xkeyboard_config, set_freqset_setuid ? false }:

stdenv.mkDerivation rec {
  name = "enlightenment-${version}";
  version = "0.20.3";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/enlightenment/${name}.tar.xz";
    sha256 = "19z3bwdzwpzwi330l5g5mj7xy6wy8xrc39zivjhm0d1ql3fh649j";
  };
  buildInputs = [ pkgconfig e19.efl e19.elementary xorg.libXdmcp xorg.libxcb
    xorg.xcbutilkeysyms xorg.libXrandr libffi pam alsaLib luajit bzip2 libuuid
    libpthreadstubs gdbm ] ++ stdenv.lib.optionals stdenv.isLinux [ libcap ];
  NIX_CFLAGS_COMPILE = [ "-I${e19.efl}/include/eo-1" "-I${e19.efl}/include/emile-1" "-I${libuuid}/include/uuid" ];
  preConfigure = ''
    export USER_SESSION_DIR=$prefix/lib/systemd/user

    substituteInPlace src/modules/xkbswitch/e_mod_parse.c \
      --replace "/usr/share/X11/xkb/rules/xorg.lst" "${xkeyboard_config}/share/X11/xkb/rules/base.lst"

    substituteInPlace "src/bin/e_import_config_dialog.c" \
      --replace "e_prefix_bin_get()" "\"${e19.efl}/bin\""
  '';

  enableParallelBuilding = true;

  # this is a hack and without this cpufreq module is not working:
  #   when set_freqset_setuid is true and "e19_freqset" is set in setuidPrograms (this is taken care of in e19 NixOS module),
  #   then this postInstall does the folowing:
  #   1. moves the "freqset" binary to "e19_freqset",
  #   2. linkes "e19_freqset" to enlightenment/bin so that,
  #   3. setuidPrograms detects it and makes appropriate stuff to /var/setuid-wrappers/e19_freqset,
  #   4. and finaly, linkes /var/setuid-wrappers/e19_freqset to original destination where enlightenment wants it
  postInstall = if set_freqset_setuid then ''
    export CPUFREQ_DIRPATH=`readlink -f $out/lib/enlightenment/modules/cpufreq/linux-gnu-*`;
    mv $CPUFREQ_DIRPATH/freqset $CPUFREQ_DIRPATH/e19_freqset
    ln -sv $CPUFREQ_DIRPATH/e19_freqset $out/bin/e19_freqset
    ln -sv /var/setuid-wrappers/e19_freqset $CPUFREQ_DIRPATH/freqset
  '' else "";
  meta = {
    description = "The Compositing Window Manager and Desktop Shell";
    homepage = http://enlightenment.org/;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ftrvxmtrx ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsd2;
  };
}
