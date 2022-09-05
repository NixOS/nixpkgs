{ mkDerivation, fetchurl, makeWrapper, lib, php }:
let
  pname = "php-cs-fixer";
  version = "3.10.0";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v${version}/php-cs-fixer.phar";
    sha256 = "sha256-dhXktw9wctIwvIlME4c4yBw7qBffetiERt1C6QWCrQo=";
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
    description = "A tool to automatically fix PHP coding standards issues";
    license = licenses.mit;
    homepage = "http://cs.sensiolabs.org/";
    maintainers = with maintainers; [ jtojnar ] ++ teams.php.members;
  };
}
