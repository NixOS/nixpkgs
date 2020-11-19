{ mkDerivation, fetchurl, pkgs, lib, php }:
let
  pname = "php-cs-fixer";
  version = "2.16.7";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v${version}/php-cs-fixer.phar";
    sha256 = "1azivqvgqy224g2ch9v9qgi31w4ml7fph3bsk8c304yvbvvfv5nh";
  };

  phases = [ "installPhase" ];
  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    install -D $src $out/libexec/php-cs-fixer/php-cs-fixer.phar
    makeWrapper ${php}/bin/php $out/bin/php-cs-fixer \
      --add-flags "$out/libexec/php-cs-fixer/php-cs-fixer.phar"
  '';

  meta = with pkgs.lib; {
    description = "A tool to automatically fix PHP coding standards issues";
    license = licenses.mit;
    homepage = "http://cs.sensiolabs.org/";
    maintainers = with maintainers; [ jtojnar ] ++ teams.php.members;
  };
}
