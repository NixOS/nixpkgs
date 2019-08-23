{ stdenv, fetchurl, fuse, zlib }:

stdenv.mkDerivation rec {
  name = "sqlar-${version}";
  version = "2018-01-07";

  src = fetchurl {
    url = "https://www.sqlite.org/sqlar/tarball/4824e73896/sqlar-src-4824e73896.tar.gz";
    sha256 = "09pikkbp93gqypn3da9zi0dzc47jyypkwc9vnmfzhmw7kpyv8nm9";
  };

  buildInputs = [ fuse zlib ];

  buildFlags = [ "sqlar" "sqlarfs" ];

  installPhase = ''
    install -D -t $out/bin sqlar sqlarfs
  '';

  meta = with stdenv.lib; {
    homepage = https://sqlite.org/sqlar;
    description = "SQLite Archive utilities";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
  };
}
