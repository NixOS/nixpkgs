{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, expat, icu }:

stdenv.mkDerivation rec {
  name = "liblcf-${version}";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "EasyRPG";
    repo = "liblcf";
    rev = version;
    sha256 = "1842hns0rbjncrhwjj7fzg9b3n47adn5jp4dg2zz34gfah3q4ig8";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ expat icu ];

  meta = with stdenv.lib; {
    homepage = https://github.com/EasyRPG/liblcf;
    license = licenses.mit;
    maintainers = with maintainers; [ yegortimoshenko ];
    platforms = platforms.linux;
  };
}
