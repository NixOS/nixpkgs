{ mkDerivation, fetchurl, makeWrapper, lib, php }:

mkDerivation rec {
  pname = "phpmd";
  version = "2.11.1";

  src = fetchurl {
    url = "https://github.com/phpmd/phpmd/releases/download/${version}/phpmd.phar";
    sha256 = "sha256-V85empARTkEdPNVjuHyy6BR5ZIHTwxJLmKMf55rv/hE=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/phpmd/phpmd.phar
    makeWrapper ${php}/bin/php $out/bin/phpmd \
      --add-flags "$out/libexec/phpmd/phpmd.phar"
    runHook postInstall
  '';

  meta = with lib; {
    broken = versionOlder php.version "7.4";
    description = "PHP code quality analyzer";
    homepage = "https://github.com/phpmd/phpmd";
    license = licenses.bsd3;
    maintainers = teams.php.members;
  };
}
