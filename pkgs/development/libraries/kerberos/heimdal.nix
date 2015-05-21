{ stdenv, fetchurl, pkgconfig, flex, yacc

# Optional Dependencies
, openldap ? null, libcap_ng ? null, sqlite ? null, openssl ? null, db ? null
, readline ? null, libedit ? null, pam ? null

#, readline, openldap, libcap_ng
#, sqlite, db, ncurses, openssl, cyrus_sasl
}:

let
  mkFlag = trueStr: falseStr: cond: name: val:
    if cond == null then null else
      "--${if cond != false then trueStr else falseStr}${name}${if val != null && cond != false then "=${val}" else ""}";
  mkEnable = mkFlag "enable-" "disable-";
  mkWith = mkFlag "with-" "without-";
  mkOther = mkFlag "" "" true;

  shouldUsePkg = pkg: if pkg != null && stdenv.lib.any (x: x == stdenv.system) pkg.meta.platforms then pkg else null;

  optOpenldap = shouldUsePkg openldap;
  optLibcap_ng = shouldUsePkg libcap_ng;
  optSqlite = shouldUsePkg sqlite;
  optOpenssl = shouldUsePkg openssl;
  optDb = shouldUsePkg db;
  optReadline = shouldUsePkg readline;
  optLibedit = shouldUsePkg libedit;
  optPam = shouldUsePkg pam;
in
stdenv.mkDerivation rec {
  name = "heimdal-1.5.3";

  src = fetchurl {
    urls = [
      "http://www.h5l.org/dist/src/${name}.tar.gz"
      "http://ftp.pdc.kth.se/pub/heimdal/src/${name}.tar.gz"
    ];
    sha256 = "19gypf9vzfrs2bw231qljfl4cqc1riyg0ai0xmm1nd1wngnpphma";
  };

  nativeBuildInputs = [ pkgconfig flex yacc ];
  buildInputs = [
    optOpenldap optLibcap_ng optSqlite optOpenssl optDb optReadline optLibedit
    optPam
  ];

  configureFlags = [
    (mkOther                         "sysconfdir"            "/etc")
    (mkOther                         "localstatedir"         "/var")
    (mkWith   (optOpenldap != null)  "openldap"              optOpenldap)
    (mkEnable (optOpenldap != null)  "hdb-openldap-module"   null)
    (mkEnable true                   "pk-init"               null)
    (mkEnable true                   "digest"                null)
    (mkEnable true                   "kx509"                 null)
    (mkWith   (optLibcap_ng != null) "capng"                 null)
    (mkWith   (optSqlite != null)    "sqlite3"               sqlite)
    (mkEnable (optSqlite != null)    "sqlite-cache"          null)
    (mkWith   false                  "libintl"               null)               # TODO libintl fix
    (mkWith   true                   "hdbdir"                "/var/lib/heimdal")
    (mkWith   (optOpenssl != null)   "openssl"               optOpenssl)
    (mkEnable true                   "pthread-support"       null)
    (mkEnable false                  "dce"                   null)               # TODO: Add support
    (mkEnable true                   "afs-support"           null)
    (mkWith   (optDb != null)        "berkeley-db"           optDb)
    (mkEnable false                  "nmdb"                  null)
    (mkEnable false                  "developer"             null)
    (mkWith   true                   "ipv6"                  null)
    (mkEnable false                  "socket-wrapper"        null)
    (mkEnable true                   "otp"                   null)
    (mkEnable false                  "osfc2"                 null)
    (mkEnable true                   "mmap"                  null)
    (mkEnable true                   "afs-string-to-key"     null)
    (mkWith   (optReadline != null)  "readline"              optReadline)
    (mkWith   (optLibedit != null)   "libedit"               optLibedit)
    (mkWith   false                  "x"                     null)
    (mkEnable true                   "kcm"                   null)
    (mkEnable true                   "heimdal-documentation" null)
  ];

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -pthread"
  '';

  # We need to build hcrypt for applications like samba
  postBuild = ''
    (cd lib/hcrypto; make)
    (cd include/hcrypto; make)
  '';

  postInstall = ''
    # Install hcrypto
    (cd lib/hcrypto; make install)
    (cd include/hcrypto; make install)

    # Doesn't succeed with --libexec=$out/sbin, so
    mv "$out/libexec/"* $out/sbin/
    rmdir $out/libexec
  '';

  meta = with stdenv.lib; {
    description = "an implementation of Kerberos 5 (and some more stuff) largely written in Sweden";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };

  passthru.implementation = "heimdal";
}
