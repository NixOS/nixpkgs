{ stdenv, fetchurl, pkgconfig, e19, xlibs, libffi, pam, alsaLib, luajit, bzip2, libpthreadstubs, gdbm, libcap, set_freqset_setuid ? false }:



stdenv.mkDerivation rec {
  name = "enlightenment-${version}";
  version = "0.19.0";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/enlightenment/${name}.tar.xz";
    sha256 = "0d9s8gwma32hj8h000k1bzibr3zj8qajcf14va3w81k87gkilxfp";
  };
  buildInputs = [ pkgconfig e19.efl e19.elementary xlibs.libXdmcp xlibs.libxcb xlibs.xcbutilkeysyms xlibs.libXrandr libffi pam alsaLib luajit bzip2 libpthreadstubs gdbm ] ++ stdenv.lib.optionals stdenv.isLinux [ libcap ];
  preConfigure = ''
    export NIX_CFLAGS_COMPILE="-I${e19.efl}/include/eo-1 -I${e19.efl}/include/ecore-imf-1 -I${e19.efl}/include/ethumb-client-1 -I${e19.efl}/include/ethumb-1 $NIX_CFLAGS_COMPILE"
    export USER_SESSION_DIR=$prefix/lib/systemd/user
  '';

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
    maintainers = [ stdenv.lib.maintainers.matejc ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsd2;
  };
}
