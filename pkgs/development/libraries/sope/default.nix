{ gnustep, lib, fetchFromGitHub , libxml2, openssl_1_1
, openldap, mysql ? null, postgresql }: with lib; gnustep.stdenv.mkDerivation rec {
  pname = "sope";
  version = "4.0.8";

  src = fetchFromGitHub {
    owner = "inverse-inc";
    repo = pname;
    rev = "SOPE-${version}";
    sha256 = "0kd7v06wfqgrcazhbi92mpdcjvh1khqkvq34rn6hiz30qxj2qmkk";
  };

  nativeBuildInputs = [ gnustep.make ];
  buildInputs = [ gnustep.base libxml2 openssl_1_1 ]
    ++ optional (openldap != null) openldap
    ++ optional (mysql != null) mysql
    ++ optional (postgresql != null) postgresql;

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
    description = "An extensive set of frameworks which form a complete Web application server environment in Objective-C";
    license = licenses.publicDomain;
    homepage = "https://github.com/inverse-inc/sope";
    platforms = platforms.linux;
    maintainers = with maintainers; [ das_j ];
  };
}
