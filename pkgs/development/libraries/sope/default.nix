{ gnustep, lib, fetchFromGitHub , libxml2, openssl_1_1
, openldap, mysql, libmysqlclient, postgresql }:
with lib;

gnustep.stdenv.mkDerivation rec {
  pname = "sope";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "inverse-inc";
    repo = pname;
    rev = "SOPE-${version}";
    sha256 = "031m8ydr4jhh29332mfbsw0i5d0cjfqfyfs55jm832dlmv4447gb";
  };

  hardeningDisable = [ "format" ];
  nativeBuildInputs = [ gnustep.make ];
  buildInputs = flatten ([ gnustep.base libxml2 openssl_1_1 ]
    ++ optional (openldap != null) openldap
    ++ optionals (mysql != null) [ libmysqlclient mysql ]
    ++ optional (postgresql != null) postgresql);

  postPatch = ''
    # Exclude NIX_ variables
    sed -i 's/grep GNUSTEP_/grep ^GNUSTEP_/g' configure
  '';

  preConfigure = ''
    export DESTDIR="$out"
  '';

  configureFlags = [ "--prefix=" "--disable-debug" "--enable-xml" "--with-ssl=ssl" ]
    ++ optional (openldap != null) "--enable-openldap"
    ++ optional (mysql != null) "--enable-mysql"
    ++ optional (postgresql != null) "--enable-postgresql";

  # Yes, this is ugly.
  preFixup = ''
    cp -rlPa $out/nix/store/*/* $out
    rm -rf $out/nix/store
  '';

  meta = {
    description = "An extensive set of frameworks which form a complete Web application server environment";
    license = licenses.publicDomain;
    homepage = "https://github.com/inverse-inc/sope";
    platforms = platforms.linux;
    maintainers = with maintainers; [ ajs124 das_j ];
  };
}
