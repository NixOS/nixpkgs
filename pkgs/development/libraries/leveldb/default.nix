{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "leveldb-${version}";
  version = "1.18";

  src = fetchFromGitHub {
    owner = "google";
    repo = "leveldb";
    rev = "v${version}";
    sha256 = "1bnsii47vbyqnbah42qgq6pbmmcg4k3fynjnw7whqfv6lpdgmb8d";
  };

  buildPhase = ''
    make all leveldbutil libmemenv.a
  '';

  installPhase = (stdenv.lib.optionalString stdenv.isDarwin ''
    for file in *.dylib*; do
      install_name_tool -id $out/lib/$file $file
    done
  '') + # XXX consider removing above after transition to cmake in the next release
  "
    mkdir -p $out/{bin,lib,include}

    cp -r include $out
    mkdir -p $out/include/leveldb/helpers
    cp helpers/memenv/memenv.h $out/include/leveldb/helpers

    cp lib* $out/lib

    cp leveldbutil $out/bin
  ";

  meta = with stdenv.lib; {
    homepage = https://github.com/google/leveldb;
    description = "Fast and lightweight key/value database library by Google";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
