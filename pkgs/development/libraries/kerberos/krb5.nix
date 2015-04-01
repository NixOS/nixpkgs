{ stdenv, fetchurl, pkgconfig, perl, ncurses, yacc, openssl, openldap }:

let
  pname = "krb5";
  version = "1.13.1";
  name = "${pname}-${version}";
  webpage = http://web.mit.edu/kerberos/;
in

stdenv.mkDerivation (rec {
  inherit name;

  src = fetchurl {
    url = "${webpage}dist/krb5/1.13/${name}-signed.tar";
    sha256 = "0gk6jvr64rf6l4xcyxn8i3fr5d1j7dhqvwyv3vw2qdkzz7yjkxjd";
  };

  buildInputs = [ pkgconfig perl ncurses yacc openssl openldap ];

  unpackPhase = ''
    tar -xf $src
    tar -xzf ${name}.tar.gz
    cd ${name}/src
  '';

  configureFlags = [ "--with-tcl=no" ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "MIT Kerberos 5";
    homepage = webpage;
    license = "MPL";
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };

  passthru.implementation = "krb5";
})
