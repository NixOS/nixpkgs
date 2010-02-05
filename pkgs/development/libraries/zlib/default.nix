{stdenv, fetchurl, static ? false}:

stdenv.mkDerivation {
  name = "zlib-1.2.3";
  src = fetchurl {
    url = http://www.zlib.net/zlib-1.2.3.tar.gz;
    md5 = "debc62758716a169df9f62e6ab2bc634";
  };
  configureFlags = if static then "" else "--shared";

  preConfigure = ''
    if test -n "$crossConfig"; then
      export CC=$crossConfig-gcc
      configureFlags=${if static then "" else "--shared"}
    fi
  '';

  # zlib doesn't like the automatic --disable-shared from the Cygwin stdenv.
  cygwinConfigureEnableShared = true;
}
