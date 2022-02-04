{ mkDerivation, fetchurl, makeWrapper, lib, php }:

mkDerivation rec {
  pname = "phpstan";
  version = "1.4.7";

  src = fetchurl {
    url = "https://github.com/phpstan/phpstan/releases/download/${version}/phpstan.phar";
    sha256 = "sha256-bsSdFfUVQnbDFH8hO1Z9sHA2w7pMHlLEx1hsgDdCUmE=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/phpstan/phpstan.phar
    makeWrapper ${php}/bin/php $out/bin/phpstan \
      --add-flags "$out/libexec/phpstan/phpstan.phar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "PHP Static Analysis Tool - discover bugs in your code without running it";
    homepage = "https://github.com/phpstan/phpstan";
    license = licenses.mit;
    longDescription = ''
      PHPStan focuses on finding errors in your code without actually
      running it. It catches whole classes of bugs even before you write
      tests for the code. It moves PHP closer to compiled languages in the
      sense that the correctness of each line of the code can be checked
      before you run the actual line.
    '';
    maintainers = teams.php.members;
  };
}
