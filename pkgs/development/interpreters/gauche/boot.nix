{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  texinfo,
  libiconv,
  gdbm,
  openssl,
  zlib,
  mbedtls,
  cacert,
}:

stdenv.mkDerivation rec {
  pname = "gauche-bootstrap";
  version = "0.9.15";

  src = fetchurl {
    url = "https://github.com/shirok/Gauche/releases/download/release${
      lib.replaceStrings [ "." ] [ "_" ] version
    }/Gauche-${version}.tgz";
    hash = "sha256-NkPie8fIgiz9b7KJLbGF9ljo42STi8LM/O2yOeNa94M=";
  };

  nativeBuildInputs = [
    pkg-config
    texinfo
  ];

  buildInputs = [
    libiconv
    gdbm
    openssl
    zlib
    mbedtls
    cacert
  ];

  postPatch = ''
    patchShebangs .
  '';

  configureFlags = [
    "--with-iconv=${libiconv}"
    "--with-dbm=gdbm"
    "--with-zlib=${zlib}"
    "--with-ca-bundle=${cacert}/etc/ssl/certs/ca-bundle.crt"
    # TODO: Enable slib
    #       Current slib in nixpkgs is specialized to Guile
    # "--with-slib=${slibGuile}/lib/slib"
  ];

  enableParallelBuilding = true;

  # TODO: Fix tests that fail in sandbox build
  doCheck = false;

  meta = {
    description = "R7RS Scheme scripting engine (released version)";
    homepage = "https://practical-scheme.net/gauche/";
    mainProgram = "gosh";
    maintainers = with lib.maintainers; [ mnacamura ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
}
