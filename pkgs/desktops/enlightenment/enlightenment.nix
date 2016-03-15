{ stdenv, fetchurl, pkgconfig, efl, elementary, xcbutilkeysyms, libXrandr, libXdmcp, libxcb,
libffi, pam, alsaLib, luajit, bzip2, libuuid, libpthreadstubs, gdbm, libcap, mesa_glu
, xkeyboard_config }:

stdenv.mkDerivation rec {
  name = "enlightenment-${version}";
  version = "0.20.6";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/enlightenment/${name}.tar.xz";
    sha256 = "11ahll68nlci214ka05whp5l32hy9lznmcdfqx3hxsmq2p7bl7zj";
  };
  buildInputs = [ pkgconfig efl elementary libXdmcp libxcb
    xcbutilkeysyms libXrandr libffi pam alsaLib luajit bzip2 libuuid
    libpthreadstubs gdbm ] ++ stdenv.lib.optionals stdenv.isLinux [ libcap ];
  NIX_CFLAGS_COMPILE = [ "-I${efl}/include/eo-1" "-I${efl}/include/emile-1" "-I${libuuid}/include/uuid" ];
  preConfigure = ''
    export USER_SESSION_DIR=$prefix/lib/systemd/user

    substituteInPlace src/modules/xkbswitch/e_mod_parse.c \
      --replace "/usr/share/X11/xkb/rules/xorg.lst" "${xkeyboard_config}/share/X11/xkb/rules/base.lst"

    substituteInPlace "src/bin/e_import_config_dialog.c" \
      --replace "e_prefix_bin_get()" "\"${efl}/bin\""
  '';

  enableParallelBuilding = true;

  # this is a hack and without this cpufreq module is not working. does the following:
  #   1. moves the "freqset" binary to "e_freqset",
  #   2. linkes "e_freqset" to enlightenment/bin so that,
  #   3. setuidPrograms detects it and makes appropriate stuff to /var/setuid-wrappers/e_freqset,
  #   4. and finaly, linkes /var/setuid-wrappers/e_freqset to original destination where enlightenment wants it
  postInstall = ''
    export CPUFREQ_DIRPATH=`readlink -f $out/lib/enlightenment/modules/cpufreq/linux-gnu-*`;
    mv $CPUFREQ_DIRPATH/freqset $CPUFREQ_DIRPATH/e_freqset
    ln -sv $CPUFREQ_DIRPATH/e_freqset $out/bin/e_freqset
    ln -sv /var/setuid-wrappers/e_freqset $CPUFREQ_DIRPATH/freqset
  '';

  meta = {
    description = "The Compositing Window Manager and Desktop Shell";
    homepage = http://enlightenment.org/;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ftrvxmtrx ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsd2;
  };
}
