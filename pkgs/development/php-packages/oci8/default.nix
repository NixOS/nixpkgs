{ buildPecl, lib, version, sha256, oracle-instantclient }:
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
