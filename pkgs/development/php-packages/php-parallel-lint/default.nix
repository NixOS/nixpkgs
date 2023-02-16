{ mkDerivation, fetchFromGitHub, makeWrapper, lib, php, php81 }:
let
  pname = "php-parallel-lint";
  version = "1.3.2";
in
mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "php-parallel-lint";
    repo = "PHP-Parallel-Lint";
    rev = "v${version}";
    # `.gitattibutes` exclude `box.json` from the archive produced git.
    forceFetchGit = true;
    sha256 = "SPP1ynxJad2m5wknGt8z94fW7Ucx8nqLvwZVmlylOgM=";
  };

  nativeBuildInputs = [
    makeWrapper
    php.packages.composer
    # box is only available for PHP ≥ 8.1 but the purpose of this tool is to validate
    # that project does not use features not available on older PHP versions.
    php81.packages.box
  ];

  buildPhase = ''
    runHook preBuild
    composer dump-autoload
    box compile
    runHook postBuild
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
    license = licenses.bsd2;
    homepage = "https://github.com/php-parallel-lint/PHP-Parallel-Lint";
    maintainers = with maintainers; [ jtojnar ] ++ teams.php.members;
  };
}
