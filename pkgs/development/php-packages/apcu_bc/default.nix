{ buildPecl, lib, pcre2, php }:

buildPecl {
  pname = "apcu_bc";

  version = "1.0.5";
  sha256 = "0ma00syhk2ps9k9p02jz7rii6x3i2p986il23703zz5npd6y9n20";

  peclDeps = [ php.extensions.apcu ];

  buildInputs = [ pcre2 ];

  postInstall = ''
    mv $out/lib/php/extensions/apc.so $out/lib/php/extensions/apcu_bc.so
  '';

  meta = with lib; {
    description = "APCu Backwards Compatibility Module";
    license = licenses.php301;
    homepage = "https://pecl.php.net/package/apcu_bc";
    maintainers = teams.php.members;
    broken = versionAtLeast php.version "8";
  };
}
