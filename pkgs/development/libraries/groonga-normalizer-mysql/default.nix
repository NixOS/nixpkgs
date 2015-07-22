{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, libgroonga }:

stdenv.mkDerivation rec {
  name = "groonga-normalizer-mysql-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "groonga";
    repo = "groonga-normalizer-mysql";
    rev = "v${version}";
    sha256 = "1s7yzggp25jajl8i28da2bz0nys90llwg5gvpyhsdqv3w3n1dysy";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ libgroonga ];

  preConfigure = ''
    export GROONGA_PLUGINS_DIR="$out/lib/groonga/plugins"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/groonga/groonga-normalizer-mysql;
    description = "provides MySQL compatible normalizers and a custom normalizers to Groonga";
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
