{ mkDerivation, fetchurl, makeWrapper, unzip, lib, php }:

mkDerivation rec {
  pname = "composer";
  version = "2.2.7";

  src = fetchurl {
    url = "https://github.com/${pname}/${pname}/releases/download/${version}/composer.phar";
    sha256 = "sha256-EAQN7WY1QZkO74zh9vpEyztKR+FF77jp5ZkHoVBoAz0=";
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
    homepage = "https://getcomposer.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ offline ] ++ teams.php.members;
  };
}
