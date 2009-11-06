{stdenv, fetchurl, perl, ncurses, yacc}:

let
  pname = "krb5";
  version = "1.6.3";
  name = "${pname}-${version}";
  webpage = http://web.mit.edu/kerberos/;
in

stdenv.mkDerivation (rec {
  inherit name;

  src = fetchurl {
    url = "${webpage}/dist/krb5/1.6/${name}-signed.tar";
    sha256 = "7a1bd7d4bd326828c8ee382ed2b69ccd6c58762601df897d6a32169d84583d2a";
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
