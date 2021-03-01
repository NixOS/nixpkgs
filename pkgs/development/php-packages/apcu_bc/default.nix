{ buildPecl, lib, pcre', php }:

buildPecl {
  pname = "apcu_bc";

  version = "1.0.5";
  sha256 = "0ma00syhk2ps9k9p02jz7rii6x3i2p986il23703zz5npd6y9n20";

  peclDeps = [ php.extensions.apcu ];

  buildInputs = [ pcre' ];

  postInstall = ''
    mv $out/lib/php/extensions/apc.so $out/lib/php/extensions/apcu_bc.so
  '';

  meta.maintainers = lib.teams.php.members;
}
