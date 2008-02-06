args: with args;

stdenv.mkDerivation rec {
  name = "libosip2-" + version;

  src = fetchurl {
    url = "mirror://gnu/osip/${name}.tar.gz";
    sha256 = "0jna6xwc42g1sh91hwzi71875mpazmnsaaq68hjirwldh39qlp69";
  };

  configureFlags = "--enable-shared --disable-static";
}
