{ stdenv, fetchFromGitHub }:

let
  inherit (stdenv.lib) optional;

in stdenv.mkDerivation rec {
  name = "iniparser-${version}";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "ndevilla";
    repo = "iniparser";
    rev = "v${version}";
    sha256 = "0339qa0qxa5z02xjcs5my8v91v0r9jm4piswrl1sa29kwyxgv5nb";
  };

  patches = ./no-usr.patch;

  doCheck = true;
  preCheck = "patchShebangs test/make-tests.sh";

  # TODO: Build dylib on Darwin
  buildFlags = (if stdenv.isDarwin then [ "libiniparser.a" ] else [ "libiniparser.so" ]) ++ [ "CC=cc" ];

  installPhase = ''
    mkdir -p $out/lib

    mkdir -p $out/include
    cp src/*.h $out/include

    mkdir -p $out/share/doc/${name}
    for i in AUTHORS INSTALL LICENSE README.md; do
      bzip2 -c -9 $i > $out/share/doc/${name}/$i.bz2;
    done;
    cp -r html $out/share/doc/${name}

  '' + (if stdenv.isDarwin then ''
    cp libiniparser.a $out/lib
  '' else ''
    cp libiniparser.so.0 $out/lib
    ln -s libiniparser.so.0 $out/lib/libiniparser.so
  '');

  meta = {
    inherit (src.meta) homepage;
    description = "Free standalone ini file parsing library";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
  };
}
