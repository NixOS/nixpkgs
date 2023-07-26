{ mkDerivation, fetchurl, makeBinaryWrapper, unzip, lib, php }:

mkDerivation (finalAttrs: {
  pname = "composer";
  version = "2.6.2";

  src = fetchurl {
    url = "https://github.com/composer/composer/releases/download/${finalAttrs.version}/composer.phar";
    hash = "sha256-iMhNSlP88cJ9Z2Lh1da3DVfG3J0uIxT9Cdv4a/YeGu8=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -D $src $out/libexec/composer/composer.phar
    makeWrapper ${php}/bin/php $out/bin/composer \
      --add-flags "$out/libexec/composer/composer.phar" \
      --prefix PATH : ${lib.makeBinPath [ unzip ]}
    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/composer/composer/releases/tag/${finalAttrs.version}";
    description = "Dependency Manager for PHP";
    homepage = "https://getcomposer.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ offline ] ++ lib.teams.php.members;
  };
})
