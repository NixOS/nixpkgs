{ stdenv, fetchurl, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  name = "libb2-${version}";
  version = "0.98";

  src = fetchurl {
    url = "https://blake2.net/${name}.tar.gz";
    sha256 = "1852gh8wwnsghdb9zhxdhw0173plpqzk684npxbl4bzk1hhzisal";
  };

  preConfigure = ''
    patchShebangs autogen.sh
    ./autogen.sh
  '';

  configureFlags = stdenv.lib.optional stdenv.hostPlatform.isx86 "--enable-fat=yes";

  nativeBuildInputs = [ autoconf automake libtool ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "The BLAKE2 family of cryptographic hash functions";
    platforms = platforms.all;
    maintainers = with maintainers; [ dfoxfranke ];
    license = licenses.cc0;
  };
}
