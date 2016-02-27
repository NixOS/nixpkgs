{stdenv, fetchurl
, libtool, autoconf, automake
, gmp, mpfr, libffi
, noUnicode ? false, 
}:
let
  s = # Generated upstream information
  rec {
    baseName="ecl";
    version="16.0.0";
    name="${baseName}-${version}";
    hash="0czh78z9i5b7jc241mq1h1gdscvdw5fbhfb0g9sn4rchwk1x8gil";
    url="https://common-lisp.net/project/ecl/files/release/16.0.0/ecl-16.0.0.tgz";
    sha256="0czh78z9i5b7jc241mq1h1gdscvdw5fbhfb0g9sn4rchwk1x8gil";
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
