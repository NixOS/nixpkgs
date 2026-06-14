{
  fetchFromGitHub,
  lib,
  stdenvNoCC,
  nix-update-script,
  nixosTests,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wallos";
  version = "4.9.5";

  src = fetchFromGitHub {
    owner = "ellite";
    repo = "Wallos";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+jgh6krf243+7pRv9qmSLq3vQJSckdjA2DvCJR61KKM=";
  };

  __structuredAttrs = true;

  strictDeps = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/wallos
    cp -r ./. $out/share/wallos/

    # Remove files that should not be served or are Docker-specific.
    rm -f $out/share/wallos/Dockerfile
    rm -f $out/share/wallos/docker-compose.yaml
    rm -f $out/share/wallos/.dockerignore
    rm -f $out/share/wallos/startup.sh
    rm -f $out/share/wallos/cronjobs
    rm -f $out/share/wallos/nginx.conf
    rm -f $out/share/wallos/nginx.default.conf
    rm -f $out/share/wallos/.gitignore

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };

    tests = {

      required-files = stdenvNoCC.mkDerivation {
        pname = "${finalAttrs.pname}-required-files-test";
        inherit (finalAttrs) version;
        dontUnpack = true;
        dontConfigure = true;
        dontBuild = true;
        installPhase = ''
          runHook preInstall

          test -f ${finalAttrs.finalPackage}/share/wallos/index.php
          test -f ${finalAttrs.finalPackage}/share/wallos/health.php
          test -f ${finalAttrs.finalPackage}/share/wallos/endpoints/db/migrate.php
          test -f ${finalAttrs.finalPackage}/share/wallos/endpoints/cronjobs/createdatabase.php
          test -d ${finalAttrs.finalPackage}/share/wallos/images/uploads
          test -d ${finalAttrs.finalPackage}/share/wallos/.tmp

          mkdir -p $out
          touch $out/success

          runHook postInstall
        '';
      };
      inherit (nixosTests) wallos;

    };
  };

  meta = {
    description = "Open-source personal subscription tracker";
    homepage = "https://github.com/ellite/Wallos";
    changelog = "https://github.com/ellite/Wallos/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      iokernel
    ];
    platforms = lib.platforms.linux;
  };
})
