{ gnustep, lib, fetchFromGitHub, fetchpatch, libxml2, openssl
, openldap, mariadb, libmysqlclient, postgresql }:

gnustep.stdenv.mkDerivation rec {
  pname = "sope";
  version = "5.8.0";

  src = fetchFromGitHub {
    owner = "inverse-inc";
    repo = pname;
    rev = "SOPE-${version}";
    hash = "sha256-sXIpKdJ5930+W+FsxQ8DZOq/49XWMM1zV8dIzbQdcbc=";
  };

  patches = [
    (fetchpatch {
      name = "sope-no-unnecessary-vars.patch";
      url = "https://github.com/Alinto/sope/commit/0751a2f11961fd7de4e2728b6e34e9ba4ba5887e.patch";
      hash = "sha256-1txj8Qehg2N7ZsiYQA2FXI4peQAE3HUwDYkJEP9WnEk=";
    })
    (fetchpatch {
      name = "sope-fix-wformat.patch";
      url = "https://github.com/Alinto/sope/commit/6adfadd5dd2da4041657ad071892f2c9b1704d22.patch";
      hash = "sha256-zCbvVdbeBeNo3/cDVdYbyUUC2z8D6Q5ga0plUoMqr98=";
    })
  ];

  hardeningDisable = [ "format" ];
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

  env.GNUSTEP_CONFIG_FILE = "/build/GNUstep.conf";

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
    maintainers = with maintainers; [ ajs124 das_j ];
  };
}
