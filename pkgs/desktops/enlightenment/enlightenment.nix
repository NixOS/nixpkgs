{ stdenv, fetchurl, pkgconfig, efl, xcbutilkeysyms, libXrandr, libXdmcp,
libxcb, libffi, pam, alsaLib, luajit, bzip2, libpthreadstubs, gdbm, libcap,
mesa_glu , xkeyboard_config }:

stdenv.mkDerivation rec {
  name = "enlightenment-${version}";
  version = "0.21.7";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/enlightenment/${name}.tar.xz";
    sha256 = "1xvngjdsa0p901vfhrh2qpa50k32hwwhc8bgi16a9b5d9byzfhvn";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    efl libXdmcp libxcb xcbutilkeysyms libXrandr libffi pam alsaLib
    luajit bzip2 libpthreadstubs gdbm
  ] ++
    stdenv.lib.optionals stdenv.isLinux [ libcap ];

  NIX_CFLAGS_COMPILE = [
    "-I${efl}/include/ecore-imf-1"
    "-I${efl}/include/emile-1"
    "-I${efl}/include/eo-1"
    "-I${efl}/include/ethumb-1"
    "-I${efl}/include/ethumb-client-1"
  ];

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
  #   3. wrappers.setuid detects it and places wrappers in /run/wrappers/bin/e_freqset,
  #   4. and finally, links /run/wrappers/bin/e_freqset to original destination where enlightenment wants it
  postInstall = ''
    export CPUFREQ_DIRPATH=`readlink -f $out/lib/enlightenment/modules/cpufreq/linux-gnu-*`;
    mv $CPUFREQ_DIRPATH/freqset $CPUFREQ_DIRPATH/e_freqset
    ln -sv $CPUFREQ_DIRPATH/e_freqset $out/bin/e_freqset
    ln -sv /run/wrappers/bin/e_freqset $CPUFREQ_DIRPATH/freqset
  '';

  meta = with stdenv.lib; {
    description = "The Compositing Window Manager and Desktop Shell";
    homepage = http://enlightenment.org/;
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ matejc tstrobel ftrvxmtrx romildo ];
  };
}
