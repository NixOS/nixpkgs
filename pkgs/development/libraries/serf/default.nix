{stdenv, fetchurl, apr, scons, openssl, aprutil, zlib, krb5, pkgconfig}:
let
  s = # Generated upstream information
  rec {
    baseName="serf";
    version="1.3.3";
    name="${baseName}-${version}";
    hash="0axdz1bbdrgvrsqmy1j0kx54y1hhhs6xmc1j7jz4fqr9fr0y1sh2";
    url="https://serf.googlecode.com/files/serf-1.3.3.tar.bz2";
    sha256="0axdz1bbdrgvrsqmy1j0kx54y1hhhs6xmc1j7jz4fqr9fr0y1sh2";
  };
  buildInputs = [
    apr scons openssl aprutil zlib krb5 pkgconfig
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };

  configurePhase = ''
    sed -e '/^env[.]Append(BUILDERS/ienv.Append(ENV={"PATH":os.environ["PATH"]})' -i SConstruct
    sed -e '/^env[.]Append(BUILDERS/ienv.Append(ENV={"NIX_CFLAGS_COMPILE":os.environ["NIX_CFLAGS_COMPILE"]})' -i SConstruct
    sed -e '/^env[.]Append(BUILDERS/ienv.Append(ENV={"NIX_LDFLAGS":os.environ["NIX_LDFLAGS"]})' -i SConstruct
  '';

  buildPhase = ''
    scons PREFIX="$out" OPENSSL="${openssl}" ZLIB="${zlib}" APR="$(echo "${apr}"/bin/*-config)" \
        APU="$(echo "${aprutil}"/bin/*-config)" GSSAPI="${krb5}" CC="${stdenv.gcc}/bin/gcc" 
  '';

  installPhase = ''
    scons install
  '';

  meta = {
    inherit (s) version;
    description = "HTTP client library based on APR";
    license = stdenv.lib.licenses.asl20 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
