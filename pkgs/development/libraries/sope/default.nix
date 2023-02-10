{ gnustep, lib, fetchFromGitHub , libxml2, openssl
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

  hardeningDisable = [ "format" ];
  nativeBuildInputs = [ gnustep.make ];
  buildInputs = lib.flatten ([ gnustep.base libxml2 openssl ]
    ++ lib.optional (openldap != null) openldap
    ++ lib.optionals (mariadb != null) [ libmysqlclient mariadb ]
    ++ lib.optional (postgresql != null) postgresql);

  postPatch = ''
    # Exclude NIX_ variables
    sed -i 's/grep GNUSTEP_/grep ^GNUSTEP_/g' configure
  '';

  preConfigure = ''
    export DESTDIR="$out"
  '';

  configureFlags = [ "--prefix=" "--disable-debug" "--enable-xml" "--with-ssl=ssl" ]
    ++ lib.optional (openldap != null) "--enable-openldap"
    ++ lib.optional (mariadb != null) "--enable-mysql"
    ++ lib.optional (postgresql != null) "--enable-postgresql";

  # Yes, this is ugly.
  preFixup = ''
    cp -rlPa $out/nix/store/*/* $out
    rm -rf $out/nix/store
  '';

  meta = with lib; {
    description = "An extensive set of frameworks which form a complete Web application server environment";
    license = licenses.publicDomain;
    homepage = "https://github.com/inverse-inc/sope";
    platforms = platforms.linux;
    maintainers = with maintainers; [ ajs124 das_j ];
  };
}
