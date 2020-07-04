{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "onig";
  version = "6.9.5_rev1";

  src = fetchFromGitHub {
    owner = "kkos";
    repo = "oniguruma";
    rev = "v${version}";
    sha256 = "1sx683hbb58gbjvla69n5vxdzwqhjqisqbfkf9xi95wr7p9ycjhl";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/kkos/oniguruma";
    description = "Regular expressions library";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
