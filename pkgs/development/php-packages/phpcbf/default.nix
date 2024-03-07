{ mkDerivation, fetchurl, lib, php, makeWrapper }:

let
  pname = "phpcbf";
  version = "3.7.2";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/${version}/phpcbf.phar";
    sha256 = "sha256-TspzKpl98IpMl+QyZuuBIvkW05uwAqAAYA/dU5P07+E=";
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
    changelog = "https://github.com/squizlabs/PHP_CodeSniffer/releases/tag/${version}";
    description = "PHP coding standard beautifier and fixer";
    license = licenses.bsd3;
    homepage = "https://squizlabs.github.io/PHP_CodeSniffer/";
    maintainers = with maintainers; [ cmcdragonkai ] ++ teams.php.members;
  };
}
