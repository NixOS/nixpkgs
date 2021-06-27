{ mkDerivation, fetchurl, lib, php, makeWrapper }:
let
  pname = "phpcbf";
  version = "3.6.0";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/${version}/phpcbf.phar";
    sha256 = "04wb1imm4934mpy2hxcmqh4cn7md1vwmfii39p6mby809325b5z1";
  };

  phases = [ "installPhase" ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    install -D $src $out/libexec/phpcbf/phpcbf.phar
    makeWrapper ${php}/bin/php $out/bin/phpcbf \
      --add-flags "$out/libexec/phpcbf/phpcbf.phar"
  '';

  meta = with lib; {
    description = "PHP coding standard beautifier and fixer";
    license = licenses.bsd3;
    homepage = "https://squizlabs.github.io/PHP_CodeSniffer/";
    maintainers = with maintainers; [ cmcdragonkai ] ++ teams.php.members;
  };
}
