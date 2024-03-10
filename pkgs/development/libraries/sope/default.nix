{ gnustep, lib, fetchFromGitHub, fetchpatch, libxml2, openssl
, openldap, mariadb, libmysqlclient, postgresql }:

gnustep.stdenv.mkDerivation rec {
  pname = "sope";
  version = "5.9.0";

  src = fetchFromGitHub {
    owner = "inverse-inc";
    repo = pname;
    rev = "SOPE-${version}";
    hash = "sha256-JZh8sC/w2MRy3UyWYGMvU47XtWKGnLuUlCsVyyxd7zg=";
  };

  patches = [
    (fetchpatch {  # https://github.com/Alinto/sope/pull/66
      name = "sope-fix-gnustep-1.29.0+.patch";
      url = "https://github.com/Alinto/sope/pull/66/commits/9ec2744cc851b11886c3ebb723138e4d672bd5c7.patch";
      hash = "sha256-JgYRwjmjlitgzYz9Jfei5XJRThP1TunPjI0g5M2wZPA=";
    })
  ];

  nativeBuildInputs = [ gnustep.make ];
  buildInputs = [ gnustep.base libxml2 openssl ]
    ++ lib.optional (openldap != null) openldap
    ++ lib.optionals (mariadb != null) [ libmysqlclient mariadb ]
    ++ lib.optional (postgresql != null) postgresql;

  # Configure directories where files are installed to. Everything is automatically
  # put into $out (thanks GNUstep) apart from the makefiles location which is where
  # makefiles are read from during build but also where the SOPE makefiles are
  # installed to in the install phase. We move them over after the installation.
  preConfigure = ''
    mkdir -p /build/Makefiles
    ln -s ${gnustep.make}/share/GNUstep/Makefiles/* /build/Makefiles
    cat <<EOF > /build/GNUstep.conf
    GNUSTEP_MAKEFILES=/build/Makefiles
    EOF
  '';

  configureFlags = [ "--prefix=" "--disable-debug" "--enable-xml" "--with-ssl=ssl" ]
    ++ lib.optional (openldap != null) "--enable-openldap"
    ++ lib.optional (mariadb != null) "--enable-mysql"
    ++ lib.optional (postgresql != null) "--enable-postgresql";

  env = {
    GNUSTEP_CONFIG_FILE = "/build/GNUstep.conf";
    NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";
  };

  # Move over the makefiles (see comment over preConfigure)
  postInstall = ''
    mkdir -p $out/share/GNUstep/Makefiles
    find /build/Makefiles -mindepth 1 -maxdepth 1 -not -type l -exec cp -r '{}' $out/share/GNUstep/Makefiles \;
  '';

  meta = with lib; {
    description = "An extensive set of frameworks which form a complete Web application server environment";
    license = licenses.publicDomain;
    homepage = "https://github.com/inverse-inc/sope";
    platforms = platforms.linux;
    maintainers = with maintainers; [];
  };
}
