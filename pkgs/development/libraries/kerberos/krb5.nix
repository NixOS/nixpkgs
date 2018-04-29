{ stdenv, fetchurl, pkgconfig, perl, yacc, bootstrap_cmds
, openssl, openldap, libedit
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "krb5-${version}";
  majorVersion = "1.15";
  version = "${majorVersion}.2";

  src = fetchurl {
    url = "${meta.homepage}dist/krb5/${majorVersion}/krb5-${version}.tar.gz";
    sha256 = "0zn8s7anb10hw3nzwjz7vg10fgmmgvwnibn2zrn3nppjxn9f6f8n";
  };

  outputs = [ "out" "dev" ];

  configureFlags = [ "--with-tcl=no" "--localstatedir=/var/lib"]
    ++ optional stdenv.isFreeBSD ''WARN_CFLAGS=""''
    ++ optionals (stdenv.buildPlatform != stdenv.hostPlatform)
       [ "krb5_cv_attr_constructor_destructor=yes,yes"
         "ac_cv_func_regcomp=yes"
         "ac_cv_printf_positional=yes"
       ];

  nativeBuildInputs = [ pkgconfig perl yacc ]
    # Provides the mig command used by the build scripts
    ++ optional stdenv.isDarwin bootstrap_cmds;
  buildInputs = [ openssl openldap libedit ];

  preConfigure = "cd ./src";

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
