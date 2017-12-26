{ stdenv, fetchurl, pkgconfig, perl, yacc, bootstrap_cmds
, openssl, openldap, libedit

# Extra Arguments
, type ? ""
}:

let
  libOnly = type == "lib";
in
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "${type}krb5-${version}";
  majorVersion = "1.15";
  version = "${majorVersion}.2";

  src = fetchurl {
    url = "${meta.homepage}dist/krb5/${majorVersion}/krb5-${version}.tar.gz";
    sha256 = "0zn8s7anb10hw3nzwjz7vg10fgmmgvwnibn2zrn3nppjxn9f6f8n";
  };

  outputs = [ "out" "dev" ];

  configureFlags = [ "--with-tcl=no" "--localstatedir=/var/lib"]
    ++ optional stdenv.isFreeBSD ''WARN_CFLAGS=""'';

  nativeBuildInputs = [ pkgconfig perl ]
    ++ optional (!libOnly) yacc
    # Provides the mig command used by the build scripts
    ++ optional stdenv.isDarwin bootstrap_cmds;
  buildInputs = [ openssl ]
    ++ optionals (!libOnly) [ openldap libedit ];

  preConfigure = "cd ./src";

  buildPhase = optionalString libOnly ''
    MAKE="make -j $NIX_BUILD_CORES -l $NIX_BUILD_CORES"
    (cd util; $MAKE)
    (cd include; $MAKE)
    (cd lib; $MAKE)
    (cd build-tools; $MAKE)
  '';

  installPhase = optionalString libOnly ''
    mkdir -p "$out"/{bin,sbin,lib/pkgconfig,share/{et,man/man1}} \
      "$dev"/include/{gssapi,gssrpc,kadm5,krb5}
    (cd util; $MAKE install)
    (cd include; $MAKE install)
    (cd lib; $MAKE install)
    (cd build-tools; $MAKE install)
    ${postInstall}
  '';

  # not via outputBin, due to reference from libkrb5.so
  postInstall = ''
    moveToOutput bin "$dev"
  '';

  enableParallelBuilding = true;

  meta = {
    description = "MIT Kerberos 5";
    homepage = http://web.mit.edu/kerberos/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };

  passthru.implementation = "krb5";
}
