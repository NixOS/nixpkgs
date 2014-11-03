{ stdenv, fetchurl, pkgconfig, e18, xlibs, libffi, pam, alsaLib, luajit, bzip2, set_freqset_setuid ? false }:

stdenv.mkDerivation rec {
  name = "enlightenment-${version}";
  version = "0.18.8";
  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/enlightenment/${name}.tar.gz";
    sha256 = "1fsigbrknkwy909p1gqwxag1bar3p413s4f6fq3qnbsd6gjbvj8l";
  };
  buildInputs = [ pkgconfig e18.efl e18.elementary xlibs.libxcb xlibs.xcbutilkeysyms xlibs.libXrandr libffi pam alsaLib luajit bzip2 ];
  preConfigure = ''
    export NIX_CFLAGS_COMPILE="-I${e18.efl}/include/eo-1 -I${e18.efl}/include/ecore-imf-1 -I${e18.efl}/include/ethumb-client-1 -I${e18.efl}/include/ethumb-1 $NIX_CFLAGS_COMPILE"
  '';

  # this is a hack and without this cpufreq module is not working:
  #   when set_freqset_setuid is true and "e18_freqset" is set in setuidPrograms (this is taken care of in e18 NixOS module),
  #   then this postInstall does the folowing:
  #   1. moves the "freqset" binary to "e18_freqset",
  #   2. linkes "e18_freqset" to enlightenment/bin so that,
  #   3. setuidPrograms detects it and makes appropriate stuff to /var/setuid-wrappers/e18_freqset,
  #   4. and finaly, linkes /var/setuid-wrappers/e18_freqset to original destination where enlightenment wants it
  postInstall = if set_freqset_setuid then ''
    export CPUFREQ_DIRPATH=`readlink -f $out/lib/enlightenment/modules/cpufreq/linux-gnu-*`;
    mv $CPUFREQ_DIRPATH/freqset $CPUFREQ_DIRPATH/e18_freqset
    ln -sv $CPUFREQ_DIRPATH/e18_freqset $out/bin/e18_freqset
    ln -sv /var/setuid-wrappers/e18_freqset $CPUFREQ_DIRPATH/freqset
  '' else "";
  meta = {
    description = "The Compositing Window Manager and Desktop Shell";
    homepage = http://enlightenment.org/;
    maintainers = [ stdenv.lib.maintainers.matejc ];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsd2;
  };
}
