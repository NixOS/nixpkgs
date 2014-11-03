{stdenv, fetchurl, perl, ncurses, yacc}:

let
  pname = "krb5";
  version = "1.12.2";
  name = "${pname}-${version}";
  webpage = http://web.mit.edu/kerberos/;
in

stdenv.mkDerivation (rec {
  inherit name;

  src = fetchurl {
    url = "${webpage}dist/krb5/1.12/${name}-signed.tar";
    sha256 = "0i1p9xx5s9q0sqnnz7f3rba07882zciw0mwc6yvv7hmm0w0iig89";
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
