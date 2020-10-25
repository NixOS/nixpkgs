{ mkDerivation, fetchurl, pkgs, lib, php }:
let
  pname = "phpcs";
  version = "3.5.8";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/${version}/phpcs.phar";
    sha256 = "037mdnpbgd9xaj556pf14h02a4a6f5zzdg58p2z1sivxcygf8aka";
  };

  phases = [ "installPhase" ];
  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    install -D $src $out/libexec/phpcs/phpcs.phar
    makeWrapper ${php}/bin/php $out/bin/phpcs \
      --add-flags "$out/libexec/phpcs/phpcs.phar"
  '';

  meta = with pkgs.lib; {
    description = "PHP coding standard tool";
    license = licenses.bsd3;
    homepage = "https://squizlabs.github.io/PHP_CodeSniffer/";
    maintainers = with maintainers; [ javaguirre ] ++ teams.php.members;
  };
}
