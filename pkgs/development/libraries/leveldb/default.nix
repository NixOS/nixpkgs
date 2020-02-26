{ stdenv, fetchFromGitHub, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  pname = "leveldb";
  version = "1.20";

  src = fetchFromGitHub {
    owner = "google";
    repo = "leveldb";
    rev = "v${version}";
    sha256 = "01kxga1hv4wp94agx5vl3ybxfw5klqrdsrb6p6ywvnjmjxm8322y";
  };

  nativeBuildInputs = []
    ++ stdenv.lib.optional stdenv.isDarwin [ fixDarwinDylibNames ];

  buildPhase = ''
    make all
  '';

  installPhase = "
    mkdir -p $out/{bin,lib,include}

    cp -r include $out
    mkdir -p $out/include/leveldb/helpers
    cp helpers/memenv/memenv.h $out/include/leveldb/helpers

    cp out-shared/lib* $out/lib
    cp out-static/lib* $out/lib

    cp out-static/leveldbutil $out/bin
  ";

  meta = with stdenv.lib; {
    homepage = https://github.com/google/leveldb;
    description = "Fast and lightweight key/value database library by Google";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
