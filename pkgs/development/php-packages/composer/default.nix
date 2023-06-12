{ mkDerivation, fetchurl, makeBinaryWrapper, unzip, lib, php }:

mkDerivation rec {
  pname = "composer";
  version = "2.5.7";

  src = fetchurl {
    url = "https://github.com/composer/composer/releases/download/${version}/composer.phar";
    sha256 = "sha256-klbEwcgDudDLemahq2xzfkjEPMbfe47J7CSXpyS/RN4=";
  };

  unpackPhase = ''
    runHook preUnpack
    php -r '(new Phar("${src}"))->extractTo("./");'
    runHook postUnpack
  '';

  nativeBuildInputs = [ makeBinaryWrapper php ];

  installPhase = ''
    runHook preInstall
    mkdir $out
    mv * $out/
    echo '#! ${php}/bin/php' | cat - $out/bin/composer > $out/bin/composer_tmp
    mv $out/bin/composer_tmp $out/bin/composer
    chmod +x $out/bin/composer
    wrapProgram $out/bin/composer \
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
