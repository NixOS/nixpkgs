{stdenv, fetchFromGitHub, ponyc }:

stdenv.mkDerivation rec {
  name = "pony-stable-${version}";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = "pony-stable";
    rev = version;
    sha256 = "0dnj9d35fa0iaka2lsc7cvn9d2qbasknn1c3gbxdyc9drf9vv6kf";
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
