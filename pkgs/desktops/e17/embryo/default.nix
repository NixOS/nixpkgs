{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  name = "embryo-${version}";
  version = "1.0.0";
  src = fetchurl {
    url = "http://download.enlightenment.org/releases/${name}.tar.gz";
    sha256 = "0ch9vps83s892vda1ss1cf1fbgzff9p51df2fip7fqlj8y1shvvx";
  };
  meta = {
    description = "Enlightenment's small Pawn based virtual machine and compiler";
    longDescription = ''
      Enlightenment's Embryo is a tiny library designed to interpret
      limited Small programs compiled by the included compiler,
      embryo_cc. It is mostly a cleaned up and smaller version of the
      original Small abstract machine. The compiler is mostly
      untouched.
    '';
    homepage = http://enlightenment.org/;
    license = with stdenv.lib.licenses; [ bsd2 bsd3 ];  # not sure
  };
}
