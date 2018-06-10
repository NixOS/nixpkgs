{stdenv, fetchFromGitHub, ponyc }:

stdenv.mkDerivation rec {
  name = "pony-stable-${version}";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = "pony-stable";
    rev = version;
    sha256 = "1g0508r66qjx857cb1cycq98b0gw7s1zn1l7bplyj1psk8mqh7kz";
  };

  buildInputs = [ ponyc ];

  installPhase = ''
    make prefix=$out install
  '';

  meta = {
    description = "A simple dependency manager for the Pony language.";
    homepage = https://www.ponylang.org;
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ dipinhora kamilchm patternspandemic ];
    platforms = stdenv.lib.platforms.unix;
  };
}
