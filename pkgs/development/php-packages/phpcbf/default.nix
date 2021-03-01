{ mkDerivation, fetchurl, pkgs, lib, php }:
let
  pname = "phpcbf";
  version = "3.5.8";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/${version}/phpcbf.phar";
    sha256 = "15ci30yvw3p9zlmzsk9s4mxzb3wax3gl9p55slhf1bzwn1xxwyb0";
  };

  phases = [ "installPhase" ];
  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    install -D $src $out/libexec/phpcbf/phpcbf.phar
    makeWrapper ${php}/bin/php $out/bin/phpcbf \
      --add-flags "$out/libexec/phpcbf/phpcbf.phar"
  '';

  meta = with pkgs.lib; {
    description = "PHP coding standard beautifier and fixer";
    license = licenses.bsd3;
    homepage = "https://squizlabs.github.io/PHP_CodeSniffer/";
    maintainers = with maintainers; [ cmcdragonkai ] ++ teams.php.members;
  };
}
