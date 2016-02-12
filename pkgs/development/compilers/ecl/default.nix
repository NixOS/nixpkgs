{stdenv, fetchurl
, libtool, autoconf, automake
, gmp, mpfr, libffi
, noUnicode ? false,
}:

let
  baseName = "ecl";
  version = "16.0.0";
in
stdenv.mkDerivation {
  name = "${baseName}-${version}";
  inherit version;

  src = fetchurl {
    url = "https://common-lisp.net/project/ecl/files/ecl-16.0.0.tgz";
    sha256 = "0czh78z9i5b7jc241mq1h1gdscvdw5fbhfb0g9sn4rchwk1x8gil";
  };

  configureFlags = [
    "--enable-threads"
    "--with-gmp-prefix=${gmp}"
    "--with-libffi-prefix=${libffi}"
  ] ++ (stdenv.lib.optional (!noUnicode) "--enable-unicode");

  buildInputs = [
    libtool autoconf automake
  ];

  propagatedBuildInputs = [
    libffi gmp mpfr
  ];

  hardening_format = false;

  postInstall = ''
    sed -e 's/@[-a-zA-Z_]*@//g' -i $out/bin/ecl-config
  '';

  meta = {
    description = "Lisp implementation aiming to be small, fast and easy to embed";
    license = stdenv.lib.licenses.mit;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
