{ mkDerivation, fetchurl, pkgs, lib, php }:
let
  pname = "composer";
  version = "2.0.8";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://getcomposer.org/download/${version}/composer.phar";
    sha256 = "0f0msrqrszhwj7ki9y5wrlwglwanmdcc132l7kz0wvj45gaz0890";
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
