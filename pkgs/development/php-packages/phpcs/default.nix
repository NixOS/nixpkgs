{ mkDerivation, fetchurl, pkgs, lib, php }:
let
  pname = "phpcs";
  version = "3.5.5";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/${version}/phpcs.phar";
    sha256 = "0jl038l55cmzn5ml61qkv4z1w4ri0h3v7h00pcb04xhz3gznlbsa";
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
