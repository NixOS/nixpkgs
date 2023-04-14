{ mkDerivation, lib, fetchFromGitHub, php, makeBinaryWrapper, fetchurl, unzip }:

php.buildComposerProject (finalAttrs: {
  pname = "composer";
  version = "2.5.5";

  composer = mkDerivation (finalComposerAttrs: {
    inherit (finalAttrs) version;
    pname = "composer-phar";

    src = fetchurl {
      url = "https://github.com/composer/composer/releases/download/${finalAttrs.version}/composer.phar";
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
      description = "Dependency Manager for PHP, shipped from the PHAR file";
      license = licenses.mit;
      homepage = "https://getcomposer.org/";
      changelog = "https://github.com/composer/composer/releases/tag/${version}";
      maintainers = with maintainers; [ offline ] ++ teams.php.members;
    };
  });

  src = fetchFromGitHub {
    owner = "composer";
    repo = "composer";
    rev = finalAttrs.version;
    hash = "sha256-eOZVJFa0GViO/jcFIonhJxAHD2DdpLOOmOPtqGMMl2w=";
  };

  vendorHash = "sha256-gv6HMd6qDf1l2jtXdI9sqfWhcxlDknU2sudhGjq9Zyw=";

  meta = with lib; {
    description = "Dependency Manager for PHP";
    license = licenses.mit;
    homepage = "https://getcomposer.org/";
    changelog = "https://github.com/composer/composer/releases/tag/${version}";
    maintainers = with maintainers; [ offline ] ++ teams.php.members;
  };
})
