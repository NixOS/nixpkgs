{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "leveldb-${version}";
  version = "1.20";

  src = fetchFromGitHub {
    owner = "google";
    repo = "leveldb";
    rev = "v${version}";
    sha256 = "01kxga1hv4wp94agx5vl3ybxfw5klqrdsrb6p6ywvnjmjxm8322y";
  };

  buildPhase = ''
    make all
  '';

  installPhase = (stdenv.lib.optionalString stdenv.isDarwin ''
    for file in out-shared/*.dylib*; do
      install_name_tool -id $out/lib/$file $file
    done
  '') + # XXX consider removing above after transition to cmake in the next release
  "
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
