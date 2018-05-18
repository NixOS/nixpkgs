{ stdenv, fetchurl, pkgconfig, texinfo, libiconv, gdbm, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "gauche-${version}";
  version = "0.9.5";

  src = fetchurl {
    url = "mirror://sourceforge/gauche/Gauche-${version}.tgz";
    sha256 = "0g77nik15whm5frxb7l0pwzd95qlq949dym5pn5p04p17lhm72jc";
  };

  nativeBuildInputs = [ pkgconfig texinfo ];

  buildInputs = [ libiconv gdbm openssl zlib ];

  configureFlags = [
    "--enable-multibyte=utf-8"
    "--with-iconv=${libiconv}"
    "--with-dbm=gdbm"
    "--with-zlib=${zlib}"
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
