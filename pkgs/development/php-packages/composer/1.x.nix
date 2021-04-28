{ mkDerivation, fetchurl, makeWrapper, unzip, lib, php }:
let
  pname = "composer";
  version = "1.10.22";
in
mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://getcomposer.org/download/${version}/composer.phar";
    sha256 = "00073smi1jja00d4bqfs6p4fqs38mki2ziy7b1kwsmiv5lcsw9v1";
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
    maintainers = with maintainers; [ offline ] ++ teams.php.members;
  };
}
