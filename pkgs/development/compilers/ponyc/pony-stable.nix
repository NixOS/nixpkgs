{stdenv, fetchFromGitHub, ponyc }:

stdenv.mkDerivation rec {
  pname = "pony-stable";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "ponylang";
    repo = "pony-stable";
    rev = version;
    sha256 = "0nzvsqvl315brp3yb4j5kl82xnkmib4jk416jjc7yrz4k3jgr278";
  };

  buildInputs = [ ponyc ];

  installFlags = [ "prefix=${placeholder "out"}" "install" ];

  meta = {
    description = "A simple dependency manager for the Pony language.";
    homepage = "https://www.ponylang.org";
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ dipinhora kamilchm patternspandemic ];
    platforms = stdenv.lib.platforms.unix;
  };
}
