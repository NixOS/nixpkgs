{ lib, stdenv, fetchurl, apr, scons, openssl, aprutil, zlib, kerberos
, pkg-config, libiconv }:

stdenv.mkDerivation rec {
  pname = "serf";
  version = "1.3.9";

  src = fetchurl {
    url = "https://www.apache.org/dist/serf/${pname}-${version}.tar.bz2";
    sha256 = "1k47gbgpp52049andr28y28nbwh9m36bbb0g8p0aka3pqlhjv72l";
  };

  nativeBuildInputs = [ pkg-config scons ];
  buildInputs = [ apr openssl aprutil zlib libiconv ]
    ++ lib.optional (!stdenv.isCygwin) kerberos;

  patches = [ ./scons.patch ];

  prefixKey = "PREFIX=";

  sconsFlags = [
    "OPENSSL=${openssl}"
    "ZLIB=${zlib}"
  ] ++ lib.optional (!stdenv.isCygwin)
    "GSSAPI=${kerberos.dev}";

  preConfigure = ''
    sconsFlags+=(
      "APR=$(echo ${apr.dev}/bin/*-config)"
      "APU=$(echo ${aprutil.dev}/bin/*-config)"
      "CC=$CC"
      "OPENSSL=${openssl}"
      "ZLIB=${zlib}"
    )
  '' + lib.optionalString (!stdenv.isCygwin) ''
    sconsFlags+=(
      "GSSAPI=${kerberos.dev}"
    )
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "HTTP client library based on APR";
    license = licenses.asl20;
    maintainers = with maintainers; [ orivej raskin ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
