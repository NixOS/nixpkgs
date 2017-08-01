{ stdenv, fetchFromGitHub, sqlite, kyotocabinet }:

stdenv.mkDerivation rec {
  name = "leveldb-${version}";
  version = "1.18";

  src = fetchFromGitHub {
    owner = "google";
    repo = "leveldb";
    rev = "v${version}";
    sha256 = "1bnsii47vbyqnbah42qgq6pbmmcg4k3fynjnw7whqfv6lpdgmb8d";
  };

  buildInputs = [ sqlite kyotocabinet ];

  buildPhase = ''
    make all db_bench{,_sqlite3,_tree_db} leveldbutil libmemenv.a
  '';

  installPhase = "
    mkdir -p $out/{bin,lib,include}
    cp -r include $out
    cp lib* $out/lib
    cp db_bench{,_sqlite3,_tree_db} leveldbutil $out/bin
    mkdir -p $out/include/leveldb/helpers
    cp helpers/memenv/memenv.h $out/include/leveldb/helpers
  ";

  meta = with stdenv.lib; {
    homepage = https://code.google.com/p/leveldb/;
    description = "Fast and lightweight key/value database library by Google";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
