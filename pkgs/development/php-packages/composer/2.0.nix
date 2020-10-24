{ mkDerivation, fetchurl, pkgs, lib, php }:
let
  pname = "composer";
  version = "2.0.0";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://getcomposer.org/download/${version}/composer.phar";
    sha256 = "11fjplbrscnw0fs5hmw4bmszg5a87ig189175407i1ip5fm5g5hk";
  };

  dontUnpack = true;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    install -D $src $out/libexec/composer/composer.phar
    makeWrapper ${php}/bin/php $out/bin/composer \
      --add-flags "$out/libexec/composer/composer.phar" \
      --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.unzip ]}
  '';

  meta = with pkgs.lib; {
    description = "Dependency Manager for PHP";
    license = licenses.mit;
    homepage = "https://getcomposer.org/";
    maintainers = with maintainers; [ offline ] ++ teams.php.members;
  };
}
