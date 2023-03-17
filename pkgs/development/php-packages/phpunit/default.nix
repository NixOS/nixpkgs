{ mkDerivation, fetchurl, makeWrapper, lib, php }:
let
  pname = "phpunit";
  version = "10.0.16";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://phar.phpunit.de/phpunit-${version}.phar";
    sha256 = "e/wUIri2y4yKI1V+U/vAD3ef2ZeKxBcFrb0Ay/rlTtM=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/phpunit/phpunit.phar
    makeWrapper ${php}/bin/php $out/bin/phpunit \
      --add-flags "$out/libexec/phpunit/phpunit.phar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "PHP testing framework";
    license = licenses.bsd3;
    homepage = "https://phpunit.de";
    maintainers = with maintainers; teams.php.members;
  };
}
