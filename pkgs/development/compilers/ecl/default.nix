{stdenv, fetchurl
, libtool, autoconf, automake
, gmp, mpfr, libffi
, noUnicode ? false, 
}:
let
  s = # Generated upstream information
  rec {
    baseName="ecl";
    version="15.3.7";
    name="${baseName}-${version}";
    hash="13wlxkd5prm93gcm2dhm7v52fl803yx93aa97lrb39z0y6xzziid";
    url="mirror://sourceforge/project/ecls/ecls/15.3/ecl-15.3.7.tgz";
    sha256="13wlxkd5prm93gcm2dhm7v52fl803yx93aa97lrb39z0y6xzziid";
  };
  buildInputs = [
    libtool autoconf automake
  ];
  propagatedBuildInputs = [
    libffi gmp mpfr
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs propagatedBuildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  patches = [ ./libffi-prefix.patch ];
  preConfigure = ''
    (cd src ; libtoolize -f)
    (cd src ; autoheader -f)
    (cd src ; aclocal)
    (cd src ; automake --add-missing -c)
    (cd src ; autoconf -f)
  '';
  configureFlags = [
    "--enable-threads"
    "--with-gmp-prefix=${gmp}"
    "--with-libffi-prefix=${libffi}"
    ]
    ++
    (stdenv.lib.optional (! noUnicode)
      "--enable-unicode")
    ;
  postInstall = ''
    sed -e 's/@[-a-zA-Z_]*@//g' -i $out/bin/ecl-config
  '';
  meta = {
    inherit (s) version;
    description = "Lisp implementation aiming to be small, fast and easy to embed";
    license = stdenv.lib.licenses.mit ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
