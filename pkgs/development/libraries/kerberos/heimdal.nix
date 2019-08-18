{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, python2, perl, yacc, flex
, texinfo, perlPackages
, openldap, libcap_ng, sqlite, openssl, db, libedit, pam
, CoreFoundation, Security, SystemConfiguration
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "heimdal";
  version = "7.7.0";

  src = fetchFromGitHub {
    owner = "heimdal";
    repo = "heimdal";
    rev = "heimdal-${version}";
    sha256 = "099qn9b8q20invvi5r8d8q9rnwpcm3nr89hx5rj7gj2ah2x5vgxs";
  };

  outputs = [ "out" "dev" "man" "info" ];

  patches = [ ./heimdal-make-missing-headers.patch ];

  nativeBuildInputs = [ autoreconfHook pkgconfig python2 perl yacc flex texinfo ]
    ++ (with perlPackages; [ JSON ]);
  buildInputs = optionals (stdenv.isLinux) [ libcap_ng ]
    ++ [ db sqlite openssl libedit openldap pam]
    ++ optionals (stdenv.isDarwin) [ CoreFoundation Security SystemConfiguration ];

  ## ugly, X should be made an option
  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--infodir=$info/share/info"
    "--enable-hdb-openldap-module"
    "--with-sqlite3=${sqlite.dev}"

  # ugly, --with-libedit is not enought, it fall back to bundled libedit
    "--with-libedit-include=${libedit.dev}/include"
    "--with-libedit-lib=${libedit}/lib"
    "--with-openssl=${openssl.dev}"
    "--without-x"
    "--with-berkeley-db"
    "--with-berkeley-db-include=${db.dev}/include"
    "--with-openldap=${openldap.dev}"
  ] ++ optionals (stdenv.isLinux) [
    "--with-capng"
  ];

  postUnpack = ''
    sed -i '/^DEFAULT_INCLUDES/ s,$, -I..,' source/cf/Makefile.am.common
    sed -i -e 's/date/date --date="@$SOURCE_DATE_EPOCH"/' source/configure.ac
  '';

  preConfigure = ''
    configureFlagsArray+=(
      "--bindir=$out/bin"
      "--sbindir=$out/sbin"
      "--libexecdir=$out/libexec/heimdal"
      "--mandir=$man/share/man"
      "--infodir=$man/share/info"
      "--includedir=$dev/include")
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

    # Do we need it?
    rm $out/bin/su

    mkdir -p $dev/bin
    mv $out/bin/krb5-config $dev/bin/

    # asn1 compilers, move them to $dev
    mv $out/libexec/heimdal/heimdal/* $dev/bin
    rmdir $out/libexec/heimdal/heimdal
  '';

  # Issues with hydra
  #  In file included from hxtool.c:34:0:
  #  hx_locl.h:67:25: fatal error: pkcs10_asn1.h: No such file or directory
  #enableParallelBuilding = true;

  meta = {
    description = "An implementation of Kerberos 5 (and some more stuff)";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };

  passthru.implementation = "heimdal";
}
