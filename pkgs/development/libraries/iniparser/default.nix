{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "iniparser-${version}";
  version = "4.1";

  src = fetchFromGitHub {
    owner = "ndevilla";
    repo = "iniparser";
    rev = "v${version}";
    sha256 = "0dhab6pad6wh816lr7r3jb6z273njlgw2vpw8kcfnmi7ijaqhnr5";
  };

  patches = ./no-usr.patch;

  doCheck = true;
  preCheck = "patchShebangs test/make-tests.sh";

  installPhase = ''
    mkdir -p $out/lib

    mkdir -p $out/include
    cp src/*.h $out/include

    mkdir -p $out/share/doc/${name}
    for i in AUTHORS INSTALL LICENSE README.md; do
      bzip2 -c -9 $i > $out/share/doc/${name}/$i.bz2;
    done;
    cp -r html $out/share/doc/${name}

    cp libiniparser.a $out/lib
    cp libiniparser.so.1 $out/lib
    ln -s libiniparser.so.1 $out/lib/libiniparser.so
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Free standalone ini file parsing library";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.primeos ];
  };
}
