{ mkDerivation, fetchurl, makeWrapper, lib, php }:

let
  pname = "php-cs-fixer";
  version = "3.16.0";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v${version}/php-cs-fixer.phar";
    sha256 = "sha256-B4VzfsSwcffR/t4eREMLH9jRWCTumYel6GM4rpumVBY=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/php-cs-fixer/php-cs-fixer.phar
    makeWrapper ${php}/bin/php $out/bin/php-cs-fixer \
      --add-flags "$out/libexec/php-cs-fixer/php-cs-fixer.phar"
    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/tag/${version}";
    description = "A tool to automatically fix PHP coding standards issues";
    license = licenses.mit;
    homepage = "https://cs.symfony.com/";
    maintainers = with maintainers; [ jtojnar ] ++ teams.php.members;
  };
}
