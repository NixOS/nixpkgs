{ mkDerivation, fetchurl, makeBinaryWrapper, unzip, lib, php }:

mkDerivation rec {
  pname = "composer";
  version = "2.5.5";

  src = fetchurl {
    url = "https://github.com/composer/composer/releases/download/${version}/composer.phar";
    sha256 = "sha256-VmptHPS+HMOsiC0qKhOBf/rlTmD1qnyRN0NIEKWAn/w=";
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

  meta = with lib; {
    description = "Dependency Manager for PHP";
    license = licenses.mit;
    homepage = "https://getcomposer.org/";
    changelog = "https://github.com/composer/composer/releases/tag/${version}";
    maintainers = with maintainers; [ offline ] ++ teams.php.members;
  };
}
