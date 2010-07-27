{stdenv, fetchurl, static ? false}:

stdenv.mkDerivation (rec {
  name = "zlib-1.2.5";
  
  src = fetchurl {
    url = "http://www.zlib.net/${name}.tar.gz";
    sha256 = "0n7rlgvjn73pyil3s1l6p77m7wkc809n934rnzxv1b1za4pfar30";
  };

  configureFlags = if static then "" else "--shared";

  preConfigure = ''
    if test -n "$crossConfig"; then
      export CC=$crossConfig-gcc
      configureFlags=${if static then "" else "--shared"}
    fi
  '';

  crossAttrs = {
    dontStrip = if static then true else false;
  };

  # zlib doesn't like the automatic --disable-shared from the Cygwin stdenv.
  cygwinConfigureEnableShared = true;
  
} // stdenv.lib.optionalAttrs (stdenv.system == "i686-cygwin") {
  patches = [ ./no-shared.patch ];
})
