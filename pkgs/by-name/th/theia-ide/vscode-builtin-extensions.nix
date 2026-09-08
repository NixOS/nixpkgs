{
  stdenv,
  fetchzip,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vscode-builtin-extensions";
  version = "1.108.2";
  src = fetchzip {
    url = "https://github.com/eclipse-theia/vscode-builtin-extensions/releases/download/${finalAttrs.version}/vscode-builtin-extensions-${finalAttrs.version}.tar.gz";
    hash = "sha256-2Yso4jLvDTGdHXSQFgLRIX3+afymyuWUUnpZPqkTdXY=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    unzip
  ];

  buildPhase = ''
    runHook preBuild

    mkdir target
    export target="$(pwd)/target"
    pushd $src
      for file in *.vsix
      do
        mkdir "$target/''${file%.vsix}"
        unzip "$file" -d "$target/''${file%.vsix}"
      done
    popd

    # These extensions are specifically excluded upstream
    rm -r $target/ms-vscode.js-debug-companion
    rm -r $target/vscode.extension-editing

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/plugins
    for extension in $target/*
    do
      mv "$extension/extension" "$out/plugins/$(basename "$extension")"
    done

    runHook postInstall
  '';
})
