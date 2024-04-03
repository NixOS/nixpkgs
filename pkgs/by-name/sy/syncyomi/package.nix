{ lib
, stdenvNoCC
, fetchFromGitHub
, buildGoModule
, jq
, moreutils
, nodePackages
, cacert
, esbuild
}:

buildGoModule rec {
  pname = "syncyomi";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "SyncYomi";
    repo = "SyncYomi";
    rev = "refs/tags/v${version}";
    hash = "sha256-wufdJkQCJD/D7kd1TSkEKRz+1Ov5lAQUsvwrCluoHIw=";
  };

  vendorHash = "sha256-/rpT6SatIZ+GVzmVg6b8Zy32pGybprObotyvEgvdL2w=";

  pnpmDeps = stdenvNoCC.mkDerivation {
    pname = "${pname}-pnpm-deps";
    inherit src version;
    sourceRoot = "${src.name}/web";

    nativeBuildInputs = [
      jq
      moreutils
      nodePackages.pnpm
      cacert
    ];

    installPhase = ''
      runHook preInstall

      export HOME=$(mktemp -d)
      pnpm config set store-dir $out
      pnpm install --frozen-lockfile --no-optional --ignore-script

      rm -rf $out/v3/tmp
      for f in $(find $out -name "*.json"); do
        sed -i -E -e 's/"checkedAt":[0-9]+,//g' $f
        jq --sort-keys . $f | sponge $f
      done

      runHook postInstall
    '';

    dontBuild = true;
    dontFixup = true;
    outputHashMode = "recursive";
    outputHash = "sha256-YOmAgzs3tDvZLRgFLkj6CY88Fm5fxbpqCUhILc8n+6c=";
  };

  nativeBuildInputs = [
    nodePackages.pnpm
  ];

  env.ESBUILD_BINARY_PATH = lib.getExe (esbuild.override {
    buildGoModule = args: buildGoModule (args // rec {
      version = "0.17.19";
      src = fetchFromGitHub {
        owner = "evanw";
        repo = "esbuild";
        rev = "v${version}";
        hash = "sha256-PLC7OJLSOiDq4OjvrdfCawZPfbfuZix4Waopzrj8qsU=";
      };
      vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
    });
  });

  postConfigure = ''
    export HOME=$(mktemp -d)
    pushd web

    pnpm config set store-dir $pnpmDeps
    pnpm install --offline --frozen-lockfile --no-optional --ignore-script
    pnpm build

    popd
  '';

  ldflags = [
    "-s" "-w"
    "-X main.version=v${version}"
  ];

  postInstall = lib.optionalString (!stdenvNoCC.isDarwin) ''
    mv $out/bin/SyncYomi $out/bin/syncyomi
  '';

  meta = {
    description = "An open-source project to synchronize Tachiyomi manga reading progress and library across multiple devices";
    homepage = "https://github.com/SyncYomi/SyncYomi";
    changelog = "https://github.com/SyncYomi/SyncYomi/releases/tag/v${version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ eriedaberrie ];
    mainProgram = "syncyomi";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
