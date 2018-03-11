{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "liblo-0.29";

  src = fetchurl {
    url = "mirror://sourceforge/liblo/liblo/0.29/${name}.tar.gz";
    sha256 = "0sn0ckc1d0845mhsaa62wf7f9v0c0ykiq796a30ja5096kib9qdc";
  };

  meta = { 
    description = "Lightweight library to handle the sending and receiving of messages according to the Open Sound Control (OSC) protocol";
    homepage = https://sourceforge.net/projects/liblo;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
