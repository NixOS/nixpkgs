{ buildPecl, lib, pkgs }:

buildPecl {
  pname = "oci8";

  version = "2.2.0";
  sha256 = "0jhivxj1nkkza4h23z33y7xhffii60d7dr51h1czjk10qywl7pyd";

  buildInputs = [ pkgs.oracle-instantclient ];
  configureFlags = [ "--with-oci8=shared,instantclient,${pkgs.oracle-instantclient.lib}/lib" ];

  postPatch = ''
    sed -i -e 's|OCISDKMANINC=`.*$|OCISDKMANINC="${pkgs.oracle-instantclient.dev}/include"|' config.m4
  '';

  meta.maintainers = lib.teams.php.members;
}
