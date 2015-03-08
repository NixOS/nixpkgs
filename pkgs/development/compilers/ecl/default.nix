{stdenv, fetchurl
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
    libffi
  ];
  propagatedBuildInputs = [
    gmp mpfr
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs propagatedBuildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  configureFlags = [
    "--enable-threads"
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
