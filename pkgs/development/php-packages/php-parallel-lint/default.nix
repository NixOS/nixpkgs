{ mkDerivation, fetchFromGitHub, makeWrapper, lib, php }:
let
  pname = "php-parallel-lint";
  version = "1.0.0";
in
mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "JakubOnderka";
    repo = "PHP-Parallel-Lint";
    rev = "v${version}";
    sha256 = "16nv8yyk2z3l213dg067l6di4pigg5rd8yswr5xgd18jwbys2vnw";
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
    mkdir -p $out/bin
    install -D parallel-lint.phar $out/libexec/php-parallel-lint/php-parallel-lint.phar
    makeWrapper ${php}/bin/php $out/bin/php-parallel-lint \
      --add-flags "$out/libexec/php-parallel-lint/php-parallel-lint.phar"
  '';

  meta = with lib; {
    description = "Tool to check syntax of PHP files faster than serial check with fancier output";
    license = licenses.bsd2;
    homepage = "https://github.com/JakubOnderka/PHP-Parallel-Lint";
    maintainers = with maintainers; [ jtojnar ] ++ teams.php.members;
  };
}
