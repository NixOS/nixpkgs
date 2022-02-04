{ mkDerivation, fetchurl, makeWrapper, lib, php }:

mkDerivation rec {
  pname = "phpcs";
  version = "3.6.2";

  src = fetchurl {
    url = "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/${version}/phpcs.phar";
    sha256 = "sha256-wIMs3OPkGcM3ARZA3evQi32qwyNEJQrHz7x5kwlQb3c=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/phpcs/phpcs.phar
    makeWrapper ${php}/bin/php $out/bin/phpcs \
      --add-flags "$out/libexec/phpcs/phpcs.phar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Tokenizes PHP files and detects violations of a defined set of coding standards";
    homepage = "https://github.com/squizlabs/PHP_CodeSniffer";
    license = licenses.bsd3;
    maintainers = with maintainers; [ javaguirre ] ++ teams.php.members;
  };
}
