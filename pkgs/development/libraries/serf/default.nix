{ stdenv, fetchurl, apr, scons, openssl, aprutil, zlib, kerberos
, pkgconfig, libiconv }:

stdenv.mkDerivation rec {
  name = "serf-1.3.9";

  src = fetchurl {
    url = "https://www.apache.org/dist/serf/${name}.tar.bz2";
    sha256 = "1k47gbgpp52049andr28y28nbwh9m36bbb0g8p0aka3pqlhjv72l";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ apr scons openssl aprutil zlib libiconv ]
    ++ stdenv.lib.optional (!stdenv.isCygwin) kerberos;

  patches = [ ./scons.patch ];

  buildPhase = ''
    scons \
      -j $NIX_BUILD_CORES \
      APR="$(echo ${apr.dev}/bin/*-config)" \
      APU="$(echo ${aprutil.dev}/bin/*-config)" \
      CC=$CC \
      OPENSSL=${openssl} \
      PREFIX="$out" \
      ZLIB=${zlib} \
      ${
        if stdenv.isCygwin then "" else "GSSAPI=${kerberos.dev}"
      }
  '';

  installPhase = ''
    scons install
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "HTTP client library based on APR";
    license = licenses.asl20;
    maintainers = with maintainers; [ orivej raskin ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
