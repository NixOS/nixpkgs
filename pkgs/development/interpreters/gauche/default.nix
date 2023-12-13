{ stdenv, lib, fetchFromGitHub, autoreconfHook, gaucheBootstrap, pkg-config, texinfo
, libiconv, gdbm, openssl, zlib, mbedtls, cacert, CoreServices }:

stdenv.mkDerivation rec {
  pname = "gauche";
  version = "0.9.13";

  src = fetchFromGitHub {
    owner = "shirok";
    repo = pname;
    rev = "release${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-XD4zJzCktGi/E9sA6BVm9JVQBVrG5119EjZNbP1pVJU=";
  };

  nativeBuildInputs = [ gaucheBootstrap pkg-config texinfo autoreconfHook ];

  buildInputs = [ libiconv gdbm openssl zlib mbedtls cacert ] ++ lib.optionals stdenv.isDarwin [ CoreServices ];

  autoreconfPhase = ''
    ./DIST gen
  '';

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

  meta = with lib; {
    description = "R7RS Scheme scripting engine";
    homepage = "https://practical-scheme.net/gauche/";
    maintainers = with maintainers; [ mnacamura ];
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
