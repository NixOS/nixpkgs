{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libproxy-0.2.3";
  src = fetchurl {
    url = http://libproxy.googlecode.com/files/libproxy-0.2.3.tar.gz;
    sha256 = "16ikq42ffrfd60j57r0l488r8zgkyxcn7l69gkijjzalndhd3pjr";
  };
}
