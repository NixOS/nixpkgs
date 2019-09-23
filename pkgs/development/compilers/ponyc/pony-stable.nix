{stdenv, fetchFromGitHub, ponyc }:

stdenv.mkDerivation rec {
  pname = "pony-stable";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = "pony-stable";
    rev = version;
    sha256 = "1wiinw35bp3zpq9kx61x2zvid7ln00jrw052ah8801s0d9dbwrdr";
  };

  buildInputs = [ ponyc ];

  installFlags = [ "prefix=${placeholder "out"}" "install" ];

  meta = {
    description = "A simple dependency manager for the Pony language.";
    homepage = https://www.ponylang.org;
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ dipinhora kamilchm patternspandemic ];
    platforms = stdenv.lib.platforms.unix;
  };
}
