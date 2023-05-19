{ mkDerivation, lib, fetchFromGitHub, php, makeBinaryWrapper, fetchurl, unzip, _7zz, git, openssh, curl }:

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
        --prefix PATH : ${lib.makeBinPath [ _7zz unzip git curl openssh ]}

      runHook postInstall
    '';

    meta = {
      description = "Dependency Manager for PHP, shipped from the PHAR file";
      license = lib.licenses.mit;
      homepage = "https://getcomposer.org/";
      changelog = "https://github.com/composer/composer/releases/tag/${finalAttrs.version}";
      maintainers = lib.teams.php.members;
    };
  });

  src = fetchFromGitHub {
    owner = "composer";
    repo = "composer";
    rev = finalAttrs.version;
    hash = "sha256-eOZVJFa0GViO/jcFIonhJxAHD2DdpLOOmOPtqGMMl2w=";
  };

  vendorHash = "sha256-3eYFONtwmHtr5LlZi3QqDOMUWUrW/aCIaI+mc7X2dIA=";

  meta = {
    description = "Dependency Manager for PHP";
    license = lib.licenses.mit;
    homepage = "https://getcomposer.org/";
    changelog = "https://github.com/composer/composer/releases/tag/${finalAttrs.version}";
    maintainers = lib.teams.php.members;
    platforms = lib.platforms.all;
  };
})
