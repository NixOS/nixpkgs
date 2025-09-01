{
  buildPecl,
  lib,
  oracle-instantclient,
  php,
}:

buildPecl {
  version = "1.1.0";
  pname = "pdo_oci";

  hash = "sha256-XKtpWH6Rn8s19Wlu15eb/6dcCpJ7Bc/pr9Pxi8L4S8c=";

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
