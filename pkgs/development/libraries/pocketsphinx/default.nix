{ stdenv
, fetchurl
, sphinxbase
, pkgconfig
, python27 # >= 2.6
, swig2 # 2.0
}:

stdenv.mkDerivation rec {
  name = "pocketsphinx-5prealpha";

  src = fetchurl {
    url = "mirror://sourceforge/cmusphinx/${name}.tar.gz";
    sha256 = "1n9yazzdgvpqgnfzsbl96ch9cirayh74jmpjf7svs4i7grabanzg";
  };

  propagatedBuildInputs = [ sphinxbase ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ python27 swig2 ];

  meta = {
    description = "Voice recognition library written in C";
    homepage = http://cmusphinx.sourceforge.net;
    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.linux;
  };
}

/* Example usage:


1.

$ cat << EOF > vocabulary.txt
oh mighty computer /1e-40/
hello world /1e-30/
EOF

2.

$ pocketsphinx_continuous -inmic yes -kws vocabulary.txt 2> /dev/null
# after you say "hello world":
hello world
...

*/
