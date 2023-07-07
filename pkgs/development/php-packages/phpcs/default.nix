{ mkDerivation, fetchurl, makeWrapper, lib, php }:

let
  pname = "phpcs";
  version = "3.7.1";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/${version}/phpcs.phar";
    sha256 = "sha256-ehQyOhSvn1gwLRVEJJLuEHaozXLAGKgWy0SWW/OpsBU=";
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
    changelog = "https://github.com/squizlabs/PHP_CodeSniffer/releases/tag/${version}";
    description = "PHP coding standard tool";
    license = licenses.bsd3;
    homepage = "https://squizlabs.github.io/PHP_CodeSniffer/";
    maintainers = with maintainers; [ javaguirre ] ++ teams.php.members;
  };
}
