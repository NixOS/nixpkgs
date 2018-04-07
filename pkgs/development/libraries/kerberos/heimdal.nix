{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, python2, perl, yacc, flex
, texinfo, perlPackages
, openldap, libcap_ng, sqlite, openssl, db, libedit, pam
, CoreFoundation, Security, SystemConfiguration
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "heimdal-${version}";
  version = "7.5.0";

  src = fetchFromGitHub {
    owner = "heimdal";
    repo = "heimdal";
    rev = "heimdal-${version}";
    sha256 = "1j38wjj4k0q8vx168k3d3k0fwa8j1q5q8f2688nnx1b9qgjd6w1d";
  };

  outputs = [ "out" "bin" "dev" "man" ];

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
      "--bindir=$out/bin" # Put binaries to $out, then move them to $bin,
                          # otherwise we go a cyclic dependecny
      "--sbindir=$out/sbin"
      "--mandir=$man/share/man"
      "--infodir=$man/share/info"
      "--includedir=$dev/include")
  '';

  # We need to build hcrypt for applications like samba
  postBuild = ''
    (cd include/hcrypto; make -j $NIX_BUILD_CORES)
    (cd lib/hcrypto; make -j $NIX_BUILD_CORES)
  '';

  # FIXME: share/info hits $bin, IDK why, but I decide is to minor to block
  postInstall = ''
    # Install hcrypto
    (cd include/hcrypto; make -j $NIX_BUILD_CORES install)
    (cd lib/hcrypto; make -j $NIX_BUILD_CORES install)

    # Do we need it?
    rm $out/bin/su

    # Doesn't succeed with --libexec=$out/sbin, so
    mkdir -p $dev/bin
    mkdir -p $bin/{,s}bin
    mv "$out/libexec/heimdal/"* $dev/bin/
    rmdir $out/libexec/heimdal
    mv "$out/libexec/"* $bin/sbin/
    rmdir $out/libexec

    mkdir -p $dev/bin && mv $out/bin/krb5-config $dev/bin/

    # Move remaining binaries to $bin
    mv $out/bin/* $bin/bin/
  '';

  # Issues with hydra
  #  In file included from hxtool.c:34:0:
  #  hx_locl.h:67:25: fatal error: pkcs10_asn1.h: No such file or directory
  #enableParallelBuilding = true;

  meta = {
    description = "An implementation of Kerberos 5 (and some more stuff)";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };

  passthru.implementation = "heimdal";
}
