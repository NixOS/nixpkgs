{ mkDerivation, fetchFromGitHub, makeWrapper, lib, php }:

mkDerivation rec {
  pname = "php-parallel-lint";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "php-parallel-lint";
    repo = "PHP-Parallel-Lint";
    rev = "v${version}";
    sha256 = "sha256-pTHH19HwqyOj5pSmH7l0JlntNVtMdu4K9Cl+qyrrg9U=";
  };

  nativeBuildInputs = [
    makeWrapper
    php.packages.composer
    php.packages.box
  ];

  buildPhase = ''
    composer dump-autoload
    box build
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D parallel-lint.phar $out/libexec/php-parallel-lint/php-parallel-lint.phar
    makeWrapper ${php}/bin/php $out/bin/php-parallel-lint \
      --add-flags "$out/libexec/php-parallel-lint/php-parallel-lint.phar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool to check syntax of PHP files faster than serial check with fancier output";
    homepage = "https://github.com/php-parallel-lint/PHP-Parallel-Lint";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jtojnar ] ++ teams.php.members;
  };
}
