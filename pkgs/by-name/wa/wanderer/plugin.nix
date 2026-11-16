{
  buildGoModule,
  tinygo,
  wanderer,
  id,
}:

buildGoModule {
  pname = "wanderer-plugin-${id}";
  inherit (wanderer) version src;

  sourceRoot = "${wanderer.src.name}/plugins";
  modRoot = id;

  vendorHash =
    {
      hammerhead = "sha256-1UwPWrwj45ssG6mty5oUy3GSZE28YiSFeMaCQvLCDmY=";
      komoot = "sha256-CzjlunRIbGdnHLdD4+Ht0dQedFI2NIi62w4fztI80EI=";
      strava = "sha256-CzjlunRIbGdnHLdD4+Ht0dQedFI2NIi62w4fztI80EI=";
    }
    .${id};

  nativeBuildInputs = [ tinygo ];

  # mirrors plugins/<id>/Makefile
  buildPhase = ''
    runHook preBuild

    export HOME=$TMPDIR
    tinygo build -target=wasi -scheduler=none -no-debug -o plugin.wasm .

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/${id} plugin.json plugin.wasm assets/*

    runHook postInstall
  '';

  doCheck = false;

  __structuredAttrs = true;

  meta = removeAttrs wanderer.meta [ "mainProgram" ] // {
    description = "${id} plugin for wanderer, a self-hosted trail database";
  };
}
