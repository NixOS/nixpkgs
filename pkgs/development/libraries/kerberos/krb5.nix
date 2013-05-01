{stdenv, fetchurl, perl, ncurses, yacc}:

let
  pname = "krb5";
  version = "1.10.5";
  name = "${pname}-${version}";
  webpage = http://web.mit.edu/kerberos/;
in

stdenv.mkDerivation (rec {
  inherit name;

  src = fetchurl {
    url = "${webpage}/dist/krb5/1.10/${name}-signed.tar";
    sha256 = "1nf195j9s8g55sh5dzbhy2l21kcdwgpn4acxrbwkvngdz9mv7g4k";
  };

  buildInputs = [ perl ncurses yacc ];

  unpackPhase = ''
    tar -xf $src
    tar -xzf ${name}.tar.gz
    cd ${name}/src
  '';

  enableParallelBuilding = true;

  meta = {
      description = "MIT Kerberos 5";
      homepage = webpage;
      license = "MPL";
  };
})
