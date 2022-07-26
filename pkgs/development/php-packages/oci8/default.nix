{ buildPecl, lib, oracle-instantclient }:
let
  version = "3.0.1";
  sha256 = "108ds92620dih5768z19hi0jxfa7wfg5hdvyyvpapir87c0ap914";
in
buildPecl {
  pname = "oci8";

  inherit version sha256;

  buildInputs = [ oracle-instantclient ];
  configureFlags = [ "--with-oci8=shared,instantclient,${oracle-instantclient.lib}/lib" ];

  postPatch = ''
    sed -i -e 's|OCISDKMANINC=`.*$|OCISDKMANINC="${oracle-instantclient.dev}/include"|' config.m4
  '';

  meta = with lib; {
    description = "Extension for Oracle Database";
    license = licenses.php301;
    homepage = "https://pecl.php.net/package/oci8";
    maintainers = teams.php.members;
  };
}
