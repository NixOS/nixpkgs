{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, python, perl, yacc, flex
, texinfo, perlPackages
, openldap, libcap_ng, sqlite, openssl, db, libedit, pam

# Extra Args
, type ? ""
}:

let
  libOnly = type == "lib";
in
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "${type}heimdal-2015-09-13";

  src = fetchFromGitHub {
    owner = "heimdal";
    repo = "heimdal";
    rev = "c81572ab5dcee3062e715b9e25ca7a20f6ec456b";
    sha256 = "1r60i4v6y5lpll0l2qpn0ycp6q6f1xjg7k1csi547zls8k96yk9s";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig python perl yacc flex ]
    ++ (with perlPackages; [ JSON ])
    ++ optional (!libOnly) texinfo;
  buildInputs = optionals (!stdenv.isFreeBSD) [ libcap_ng db ]
    ++ [ sqlite openssl libedit ]
    ++ optionals (!libOnly) [ openldap pam ];

  ## ugly, X should be made an option
  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--enable-hdb-openldap-module"
    "--with-sqlite3=${sqlite}"
    "--with-libedit=${libedit}"
    "--with-openssl=${openssl}"
    "--without-x"
    "--with-berkeley-db=${db}"
  ] ++ optionals (!libOnly) [
    "--with-openldap=${openldap}"
  ] ++ optionals (!stdenv.isFreeBSD) [
    "--with-capng"
  ];

  buildPhase = optionalString libOnly ''
    (cd include; make -j $NIX_BUILD_CORES)
    (cd lib; make -j $NIX_BUILD_CORES)
    (cd tools; make -j $NIX_BUILD_CORES)
    (cd include/hcrypto; make -j $NIX_BUILD_CORES)
    (cd lib/hcrypto; make -j $NIX_BUILD_CORES)
  '';

  installPhase = optionalString libOnly ''
    (cd include; make -j $NIX_BUILD_CORES install)
    (cd lib; make -j $NIX_BUILD_CORES install)
    (cd tools; make -j $NIX_BUILD_CORES install)
    (cd include/hcrypto; make -j $NIX_BUILD_CORES install)
    (cd lib/hcrypto; make -j $NIX_BUILD_CORES install)
    rm -rf $out/{libexec,sbin,share}
    find $out/bin -type f | grep -v 'krb5-config' | xargs rm
  '';

  # We need to build hcrypt for applications like samba
  postBuild = ''
    (cd include/hcrypto; make -j $NIX_BUILD_CORES)
    (cd lib/hcrypto; make -j $NIX_BUILD_CORES)
  '';

  postInstall = ''
    # Install hcrypto
    (cd include/hcrypto; make -j $NIX_BUILD_CORES install)
    (cd lib/hcrypto; make -j $NIX_BUILD_CORES install)

    # Doesn't succeed with --libexec=$out/sbin, so
    mv "$out/libexec/"* $out/sbin/
    rmdir $out/libexec
  '';

  # Issues with hydra
  #  In file included from hxtool.c:34:0:
  #  hx_locl.h:67:25: fatal error: pkcs10_asn1.h: No such file or directory
  #enableParallelBuilding = true;

  meta = {
    description = "An implementation of Kerberos 5 (and some more stuff)";
    license = licenses.bsd3;
    platforms = platforms.linux ++ platforms.freebsd;
    maintainers = with maintainers; [ wkennington ];
  };

  passthru.implementation = "heimdal";
}
