{ mkDerivation, fetchurl, lib, php, makeWrapper }:

mkDerivation rec {
  pname = "phpcbf";
  version = "3.6.2";

  src = fetchurl {
    url = "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/${version}/phpcbf.phar";
    sha256 = "sha256-KNdKqqetJRxO0jSB5/oYt1VFDuV4ctIr4Oy4/iH1Dcg=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/phpcbf/phpcbf.phar
    makeWrapper ${php}/bin/php $out/bin/phpcbf \
      --add-flags "$out/libexec/phpcbf/phpcbf.phar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "PHP coding standard beautifier and fixer";
    license = licenses.bsd3;
    homepage = "https://squizlabs.github.io/PHP_CodeSniffer/";
    maintainers = with maintainers; [ cmcdragonkai ] ++ teams.php.members;
  };
}
