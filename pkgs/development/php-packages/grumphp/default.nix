{ mkDerivation, fetchurl, makeWrapper, lib, php }:

mkDerivation rec {
  pname = "grumphp";
  version = "1.15.0";

  src = fetchurl {
    url = "https://github.com/phpro/${pname}/releases/download/v${version}/${pname}.phar";
    sha256 = "sha256-EqzJb7DYZb7PnebErLVI/EZLxj0m26cniZlsu1feif0=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/${pname}/grumphp.phar
    makeWrapper ${php}/bin/php $out/bin/grumphp \
      --add-flags "$out/libexec/${pname}/grumphp.phar"
    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/phpro/grumphp/releases/tag/v${version}";
    description = "A PHP code-quality tool";
    homepage = "https://github.com/phpro/grumphp";
    license = licenses.mit;
    maintainers = teams.php.members;
  };
}
