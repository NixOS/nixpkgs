{
  buildPecl,
  lib,
  oracle-instantclient,
  php,
}:

let
  versionData =
    if (lib.versionOlder php.version "8.1") then
      {
        version = "3.0.1";
        sha256 = "108ds92620dih5768z19hi0jxfa7wfg5hdvyyvpapir87c0ap914";
      }
    else if (lib.versionOlder php.version "8.2") then
      {
        version = "3.2.1";
        sha256 = "sha256-zyF703DzRZDBhlNFFt/dknmZ7layqhgjG1/ZDN+PEsg=";
      }
    else
      {
        version = "3.4.0";
        sha256 = "sha256-YPXDijyQxGHZbWHFEpx4xTq3hCJU3ANVIi5t0OqMEag=";
      };
in
buildPecl {
  pname = "oci8";

  inherit (versionData) version sha256;

  buildInputs = [ oracle-instantclient ];
  configureFlags = [ "--with-oci8=shared,instantclient,${oracle-instantclient.lib}/lib" ];

  postPatch = ''
    sed -i -e 's|OCISDKMANINC=`.*$|OCISDKMANINC="${oracle-instantclient.dev}/include"|' config.m4
  '';

  meta = with lib; {
    description = "Extension for Oracle Database";
    license = licenses.php301;
    homepage = "https://pecl.php.net/package/oci8";
    teams = [ teams.php ];
  };
}
