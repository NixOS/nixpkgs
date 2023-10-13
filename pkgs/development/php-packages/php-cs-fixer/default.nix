{ mkDerivation, fetchurl, makeWrapper, lib, php }:

let
  pname = "php-cs-fixer";
  version = "3.34.1";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v${version}/php-cs-fixer.phar";
    sha256 = "sha256-wVqGINDvVr11QDamo1SHmkwKuDqu8GRDFBNsk3C7mt8=";
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
    maintainers = with maintainers; [ ] ++ teams.php.members;
  };
}
