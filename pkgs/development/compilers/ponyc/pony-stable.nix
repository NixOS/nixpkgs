{stdenv, fetchFromGitHub, ponyc }:

stdenv.mkDerivation {
  name = "pony-stable-unstable-2017-04-20";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = "pony-stable";
    rev = "b2ea566b02ec40480f888652b04eaa5f191a241e";
    sha256 = "1bixkxccsrnyip3yp42r14rbhk832pvzwbkh6ash4ip2isxa6b19";
  };

  buildInputs = [ ponyc ];

  installPhase = ''
    make prefix=$out install
  '';

  meta = {
    description = "A simple dependency manager for the Pony language.";
    homepage = http://www.ponylang.org;
    license = stdenv.lib.licenses.bsd2;
    maintainers = [ stdenv.lib.maintainers.dipinhora ];
    platforms = stdenv.lib.platforms.unix;
  };
}
