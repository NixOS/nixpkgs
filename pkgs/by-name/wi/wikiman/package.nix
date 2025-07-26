{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,

  fzf,
  ripgrep,
  gawk,
  w3m,
  coreutils,
  parallel,

  fetchzip,
  sources ? [ ],
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wikiman";
  version = "2.14.1";

  src = fetchFromGitHub {
    owner = "filiparag";
    repo = "wikiman";
    tag = finalAttrs.version;
    hash = "sha256-EvYMUHKFJhSFyoW85EEzI7q5OMGGe9c+A2JlkAoxt3o=";
  };

  patches = [ ./fix-paths.patch ];

  # Allow wikiman to use symlinked sources
  postPatch = ''
    substituteInPlace wikiman.sh sources/*.sh --replace-fail '-type f' '-type f,l'
  '';

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  postInstall =
    ''
      mv $out/usr/* $out
      rmdir $out/usr
    ''
    + lib.concatMapStringsSep "\n" (v: ''
      ln -s ${v}/share/doc/* -t $out/share/doc
    '') sources;

  postFixup =
    let
      runtimeDependencies = [
        fzf
        ripgrep
        gawk
        w3m
        coreutils
        parallel
      ];
    in
    ''
      wrapProgram $out/bin/wikiman \
        --prefix PATH : "${lib.makeBinPath runtimeDependencies}":$out/bin \
        --set "conf_sys_usr" "$out"
    '';

  # Couldn't do a versionCheckHook since the script fails when no sources are found.
  # Even when just printing the version. Yeah.

  passthru = {
    updateScript = ./update.nu;

    sources = lib.pipe ./sources.json [
      lib.importJSON
      (map (v: {
        inherit (v) name;
        value = stdenvNoCC.mkDerivation {
          pname = "wikiman-source-${v.name}";
          inherit (finalAttrs) version;

          src = fetchzip {
            inherit (v) url hash;
          };

          dontConfigure = true;
          dontBuild = true;

          installPhase = ''
            runHook preInstall
            mkdir -p $out/share
            cp -r $src/share/doc $out/share
            runHook postInstall
          '';
        };
      }))
      lib.listToAttrs
    ];
  };

  meta = {
    description = "Offline search engine for manual pages, Arch Wiki, Gentoo Wiki and other documentation";
    homepage = "https://github.com/filiparag/wikiman";
    license = with lib.licenses; [ mit ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "wikiman";
  };
})
