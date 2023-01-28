{ mkDerivation, fetchurl, makeWrapper, unzip, lib, php }:

let
  pname = "composer";
  version = "2.5.1";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/composer/composer/releases/download/${version}/composer.phar";
    sha256 = "sha256-8blP7hGlvWoarl13yNomnfJ8cF/MgG6/TIwub6hkXCA=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/composer/composer.phar
    makeWrapper ${php}/bin/php $out/bin/composer \
      --add-flags "$out/libexec/composer/composer.phar" \
      --prefix PATH : ${lib.makeBinPath [ unzip ]}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Dependency Manager for PHP";
    license = licenses.mit;
    homepage = "https://getcomposer.org/";
    changelog = "https://github.com/composer/composer/releases/tag/${version}";
    maintainers = with maintainers; [ offline ] ++ teams.php.members;
  };
}
