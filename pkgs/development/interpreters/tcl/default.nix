{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "tcl-8.4.16";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/tcl/tcl8.4.16-src.tar.gz;
    sha256 = "0v9mh53kdvfm4kxgsw8gfxsfl8kvbnnp22bpwyyg5sa4jyjjbs93";
  };
}
