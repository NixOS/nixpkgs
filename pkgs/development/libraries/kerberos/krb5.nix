{stdenv, fetchurl, perl, ncurses, yacc}:

let
  pname = "krb5";
  version = "1.11.3";
  name = "${pname}-${version}";
  webpage = http://web.mit.edu/kerberos/;
in

stdenv.mkDerivation (rec {
  inherit name;

  src = fetchurl {
    url = "${webpage}/dist/krb5/1.11/${name}-signed.tar";
    sha256 = "1daiaxgkxcryqs37w28v4x1vajqmay4l144d1zd9c2d7jjxr9gcs";
  };

  buildInputs = [ perl ncurses yacc ];

  unpackPhase = ''
    tar -xf $src
    tar -xzf ${name}.tar.gz
    cd ${name}/src
  '';

  configureFlags = "--with-tcl=no";

  #doCheck = true; # report: No suitable file for testing purposes

  enableParallelBuilding = true;

  meta = {
    description = "MIT Kerberos 5";
    homepage = webpage;
    license = "MPL";
  };
})
