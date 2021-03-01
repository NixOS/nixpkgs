{ buildPecl, lib, pkgs, version, sha256 }:
buildPecl {
  pname = "oci8";

  inherit version sha256;

  buildInputs = [ pkgs.oracle-instantclient ];
  configureFlags = [ "--with-oci8=shared,instantclient,${pkgs.oracle-instantclient.lib}/lib" ];

  postPatch = ''
    sed -i -e 's|OCISDKMANINC=`.*$|OCISDKMANINC="${pkgs.oracle-instantclient.dev}/include"|' config.m4
  '';

  meta.maintainers = lib.teams.php.members;
}
