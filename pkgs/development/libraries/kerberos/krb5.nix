{ stdenv, fetchurl, pkgconfig, perl
, yacc, bootstrap_cmds

# Optional Dependencies
, libedit ? null, readline ? null, ncurses ? null, libverto ? null
, openldap ? null

# Crypto Dependencies
, openssl ? null, nss ? null, nspr ? null

# Extra Arguments
, prefix ? ""
}:

with stdenv;
let
  libOnly = prefix == "lib";

  optOpenssl = shouldUsePkg openssl;
  optNss = shouldUsePkg nss;
  optNspr = shouldUsePkg nspr;
  optLibedit = if libOnly then null else shouldUsePkg libedit;
  optReadline = if libOnly then null else shouldUsePkg readline;
  optNcurses = if libOnly then null else shouldUsePkg ncurses;
  optLibverto = shouldUsePkg libverto;
  optOpenldap = if libOnly then null else shouldUsePkg openldap;

  # Prefer the openssl implementation
  cryptoStr = if optOpenssl != null then "openssl"
    else if optNss != null && optNspr != null then "nss"
    else "builtin";

  cryptoInputs = {
    "openssl" = [ optOpenssl ];
    "nss" = [ optNss optNspr ];
    "builtin" = [ ];
  }.${cryptoStr};

  tlsStr = if optOpenssl != null then "openssl"
    else "no";

  tlsInputs = {
    "openssl" = [ optOpenssl ];
    "no" = [ ];
  }.${tlsStr};

  # Libedit is less buggy in krb5, readline breaks tests
  lineParserStr = if optLibedit != null then "libedit"
    else if optReadline != null && optNcurses != null then "readline"
    else "no";

  lineParserInputs = {
    "libedit" = [ optLibedit ];
    "readline" = [ optReadline optNcurses ];
    "no" = [ ];
  }.${lineParserStr};
in
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "${prefix}krb5-${version}";
  version = "1.13.2";

  src = fetchurl {
    url = "${meta.homepage}dist/krb5/1.13/krb5-${version}-signed.tar";
    sha256 = "1qbdzyrws7d0q4filsibh28z54pd5l987jr0ygv43iq9085w6a75";
  };

  nativeBuildInputs = [ pkgconfig perl ];
  buildInputs = [ yacc optOpenssl optLibverto optOpenldap ]
    ++ cryptoInputs ++ tlsInputs ++ lineParserInputs
    # Provides the mig command used by the build scripts
    ++ stdenv.lib.optional stdenv.isDarwin bootstrap_cmds;

  unpackPhase = ''
    tar -xf $src
    tar -xzf krb5-${version}.tar.gz
    cd krb5-${version}/src
  '';

  configureFlags = [
    (mkOther                                "sysconfdir"          "/etc")
    (mkOther                                "localstatedir"       "/var")
    (mkEnable false                         "athena"              null)
    (mkWith   false                         "vague-errors"        null)
    (mkWith   true                          "crypto-impl"         cryptoStr)
    (mkWith   true                          "pkinit-crypto-impl"  cryptoStr)
    (mkWith   true                          "tls-impl"            tlsStr)
    (mkEnable true                          "aesni"               null)
    (mkEnable true                          "kdc-lookaside-cache" null)
    (mkEnable (optOpenssl != null)          "pkinit"              null)
    (mkWith   (lineParserStr == "libedit")  "libedit"             null)
    (mkWith   (lineParserStr == "readline") "readline"            null)
    (mkWith   (optLibverto != null)         "system-verto"        null)
    (mkWith   (optOpenldap != null)         "ldap"                null)
    (mkWith   false                         "tcl"                 null)
    (mkWith   false                         "system-db"           null)  # Requires db v1.85
  ];

  buildPhase = optionalString libOnly ''
    (cd util; make)
    (cd include; make)
    (cd lib; make)
    (cd build-tools; make)
  '';

  installPhase = optionalString libOnly ''
    mkdir -p $out/{bin,include/{gssapi,gssrpc,kadm5,krb5},lib/pkgconfig,sbin,share/{et,man/man1}}

    (cd util; make install)
    (cd include; make install)
    (cd lib; make install)
    (cd build-tools; make install)

    rm -rf $out/{sbin,share}
    find $out/bin -type f | grep -v 'krb5-config' | xargs rm
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://web.mit.edu/kerberos/;
    description = "MIT Kerberos 5";
    license = "MPL";
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };

  passthru.implementation = "krb5";
}
