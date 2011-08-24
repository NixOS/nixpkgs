{ stdenv, fetchurl, sphinxbase, pkgconfig }:

stdenv.mkDerivation rec {
  name = "pocketsphinx-0.7";

  src = fetchurl {
    url = "mirror://sourceforge/cmusphinx/${name}.tar.gz";
    sha256 = "0m94x5pridagr0hgmnidrf4z44zcya05d8fh67k0cc0mmghsq36f";
  };

  propagatedBuildInputs = [ sphinxbase ];

  buildInputs = [ pkgconfig ];

  meta = {
    description = "Voice recognition library written in C";
    homepage = http://cmusphinx.sourceforge.net;
    license = "free-non-copyleft";
    maintainers = [ stdenv.lib.maintainers.shlevy ];
  };
}
