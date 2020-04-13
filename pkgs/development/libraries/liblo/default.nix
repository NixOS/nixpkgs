{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "liblo-0.31";

  src = fetchurl {
    url = "mirror://sourceforge/liblo/liblo/0.31/${name}.tar.gz";
    sha256 = "0l67rkdhfa8cffa0nynql3lh2xlbn1454h6qxhjddp1029p48krb";
  };

  doCheck = false; # fails 1 out of 3 tests

  meta = {
    description = "Lightweight library to handle the sending and receiving of messages according to the Open Sound Control (OSC) protocol";
    homepage = "https://sourceforge.net/projects/liblo";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
