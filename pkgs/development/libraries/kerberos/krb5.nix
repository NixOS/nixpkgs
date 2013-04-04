{stdenv, fetchurl, perl, ncurses, yacc}:

let
  pname = "krb5";
  version = "1.11.1";
  name = "${pname}-${version}";
  webpage = http://web.mit.edu/kerberos/;
in

stdenv.mkDerivation (rec {
  inherit name;

  src = fetchurl {
    url = "${webpage}/dist/krb5/1.11/${name}-signed.tar";
    sha256 = "0s07sbwrj3c61gc29g016csim04azb9h74rf5595fxzqlzv0y8rs";
  };

  buildInputs = [ perl ncurses yacc ];

  unpackPhase = ''
    tar -xf $src
    tar -xzf ${name}.tar.gz
    cd ${name}/src
  '';

  #doCheck = true; # report: No suitable file for testing purposes

  meta = {
    description = "MIT Kerberos 5";
    homepage = webpage;
    license = "MPL";
  };
})
