{ mkDerivation, fetchurl, makeWrapper, lib, php }:
mkDerivation rec {
  pname = "grumphp";
  version = "1.8.1";

  src = fetchurl {
    url = "https://github.com/phpro/${pname}/releases/download/v${version}/${pname}.phar";
    sha256 = "sha256-3XPMyH2F3ZfRr8DmvlBY3Z6uolhaRraQxwKIskIwPq8=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/${pname}/grumphp.phar
    makeWrapper ${php}/bin/php $out/bin/grumphp \
      --add-flags "$out/libexec/${pname}/grumphp.phar"
    runHook postInstall
  '';

  meta = with lib; {
    broken = versionOlder php.version "8.0";
    description = "A PHP code-quality tool";
    homepage = "https://github.com/phpro/grumphp";
    license = licenses.mit;
    maintainers = teams.php.members;
  };
}
