{ mkDerivation, fetchurl, makeWrapper, lib, php }:

mkDerivation (finalAttrs: {
  pname = "grumphp";
  version = "1.15.0";

  src = fetchurl {
    url = "https://github.com/phpro/grumphp/releases/download/v${finalAttrs.version}/grumphp.phar";
    sha256 = "sha256-EqzJb7DYZb7PnebErLVI/EZLxj0m26cniZlsu1feif0=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/grumphp/grumphp.phar
    makeWrapper ${php}/bin/php $out/bin/grumphp \
      --add-flags "$out/libexec/grumphp/grumphp.phar"
    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/phpro/grumphp/releases/tag/v${finalAttrs.version}";
    description = "A PHP code-quality tool";
    homepage = "https://github.com/phpro/grumphp";
    license = licenses.mit;
    maintainers = teams.php.members;
  };
})
