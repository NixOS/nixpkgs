{ stdenv, fetchurl, pkgconfig, eina }:
stdenv.mkDerivation rec {
  name = "embryo-${version}";
  version = "1.2.0-alpha";
  src = fetchurl {
    url = "http://download.enlightenment.org/releases/${name}.tar.bz2";
    sha256 = "0hcjlf0rljz4zs1y5l4h0gn2gyqb1h4msfsaps8flaym4mxrvvd9";
  };
  buildInputs = [ pkgconfig eina ];
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
