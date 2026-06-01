{
  buildPecl,
  lib,
  oracle-instantclient,
  php,
}:

buildPecl {
  version = "1.2.0";
  pname = "pdo_oci";

  hash = "sha256-xV5ZvOtowkPntuqQ0dSyhpC5l+MDkvEKHoRi8S0/k34=";

  buildInputs = [ oracle-instantclient ];
  configureFlags = [ "--with-pdo-oci=instantclient,${oracle-instantclient.lib}/lib" ];

  internalDeps = [ php.extensions.pdo ];
  postPatch = ''
    sed -i -e 's|OCISDKMANINC=`.*$|OCISDKMANINC="${oracle-instantclient.dev}/include"|' config.m4
  '';

  meta = {
    changelog = "https://pecl.php.net/package-changelog.php?package=PDO_OCI";
    description = "PHP PDO_OCI extension lets you access Oracle Database";
    license = lib.licenses.php301;
    homepage = "https://pecl.php.net/package/pdo_oci";
    teams = [ lib.teams.php ];
  };
}
