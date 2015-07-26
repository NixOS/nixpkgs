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
  name = "${type}heimdal-2015-06-17";

  src = fetchFromGitHub {
    owner = "heimdal";
    repo = "heimdal";
    rev = "be63a2914adcbea7d42d56e674ee6edb4883ebaf";
    sha256 = "147gv49gmy94y6f0x1vx523qni0frgcp3r7fill0r06rkfgfzc0j";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig python perl yacc flex ]
    ++ (with perlPackages; [ JSON ])
    ++ optional (!libOnly) texinfo;
  buildInputs = [ libcap_ng sqlite openssl db libedit ]
    ++ optionals (!libOnly) [ openldap pam ];

  ## ugly, X should be made an option
  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--enable-hdb-openldap-module"
    "--with-capng"
    "--with-sqlite3=${sqlite}"
    "--with-berkeley-db=${db}"
    "--with-libedit=${libedit}"
    "--with-openssl=${openssl}"
    "--without-x"
  ] ++ optionals (!libOnly) [
    "--with-openldap=${openldap}"
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

  enableParallelBuilding = true;

  meta = {
    description = "An implementation of Kerberos 5 (and some more stuff)";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };

  passthru.implementation = "heimdal";
}
