{
  lib,
  stdenv,
  fetchurl,
  fuse,
  zlib,
  withFuse ? true,
}:

stdenv.mkDerivation {
  pname = "sqlar";
  version = "2018-01-07";

  src = fetchurl {
    url = "https://www.sqlite.org/sqlar/tarball/4824e73896/sqlar-src-4824e73896.tar.gz";
    sha256 = "09pikkbp93gqypn3da9zi0dzc47jyypkwc9vnmfzhmw7kpyv8nm9";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace 'gcc' '${stdenv.cc.targetPrefix}cc'
  '';

  buildInputs = [ zlib ] ++ lib.optional withFuse fuse;

  buildFlags = [
    "CFLAGS=-Wno-error"
    "sqlar"
  ]
  ++ lib.optional withFuse "sqlarfs";

  installPhase = ''
    install -D -t $out/bin sqlar
  ''
  + lib.optionalString withFuse ''
    install -D -t $out/bin sqlarfs
  '';

  meta = {
    homepage = "https://sqlite.org/sqlar";
    description = "SQLite Archive utilities";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
