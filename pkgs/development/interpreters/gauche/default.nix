{ stdenv, fetchurl, pkgconfig, texinfo, libiconv, gdbm, openssl, zlib
, mbedtls, cacert
}:

stdenv.mkDerivation rec {
  name = "gauche-${version}";
  version = "0.9.8";

  src = fetchurl {
    url = "mirror://sourceforge/gauche/Gauche-${version}.tgz";
    sha256 = "0jxp1ladpy8kvfvk561c64spf1c3d6giqla6zscqkd6qa480vcry";
  };

  nativeBuildInputs = [ pkgconfig texinfo ];

  buildInputs = [ libiconv gdbm openssl zlib mbedtls cacert ];

  postPatch = ''
    patchShebangs .
  '';

  configureFlags = [
    "--with-iconv=${libiconv}"
    "--with-dbm=gdbm"
    "--with-zlib=${zlib}"
    "--with-ca-bundle=$NIX_SSL_CERT_FILE"
    # TODO: Enable slib
    #       Current slib in nixpkgs is specialized to Guile
    # "--with-slib=${slibGuile}/lib/slib"
  ];

  enableParallelBuilding = true;

  # TODO: Fix tests that fail in sandbox build
  doCheck = false;

  meta = with stdenv.lib; {
    description = "R7RS Scheme scripting engine";
    homepage = https://practical-scheme.net/gauche/;
    maintainers = with maintainers; [ mnacamura ];
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
