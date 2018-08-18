{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libclthreads-${version}";
  version = "2.4.0";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/clthreads-${version}.tar.bz2";
    sha256 = "1s8xx99z6llv46cvkllmd72v2pkzbfl5gngcql85mf14mxkdb7x6";
  };

  patchPhase = ''
    # Fix hardcoded paths to executables
    sed -e "s@/usr/bin/install@install@" -i ./Makefile
    sed -e "s@/sbin/ldconfig@ldconfig@" -i ./Makefile

    # Remove useless symlink: /lib64 -> /lib
    sed -e '/ln -sf \$(CLTHREADS_MIN) \$(PREFIX)\/\$(LIBDIR)\/\$(CLTHREADS_SO)/d' -i ./Makefile
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "SUFFIX=''"
  ];

  preInstall = ''
    # The Makefile does not create the include directory
    mkdir -p $out/include
  '';

  postInstall = ''
    ln -s $out/lib/libclthreads.so.${version} $out/lib/libclthreads.so
  '';

  meta = with stdenv.lib; {
    description = "Zita thread library";
    homepage = http://kokkinizita.linuxaudio.org/linuxaudio/downloads/index.html;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ magnetophon ];
    platforms = platforms.linux;
  };
}
