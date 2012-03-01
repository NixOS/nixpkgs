{stdenv, fetchurl, perl, ncurses, yacc}:

let
  pname = "krb5";
  version = "1.10";
  name = "${pname}-${version}";
  webpage = http://web.mit.edu/kerberos/;
in

stdenv.mkDerivation (rec {
  inherit name;

  src = fetchurl {
    url = "${webpage}/dist/krb5/1.10/${name}-signed.tar";
    sha256 = "1pa4m6538drb51gsqxbbxlsnc9fm9ccid9m2s3pv3di5l0a7l8bg";
  };

  buildInputs = [ perl ncurses yacc ];

  unpackPhase = ''
    tar -xf $src
    tar -xzf ${name}.tar.gz
    cd ${name}/src
  '';

  meta = { 
      description = "MIT Kerberos 5";
      homepage = webpage;
      license = "MPL";
  };
})
