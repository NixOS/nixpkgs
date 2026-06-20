{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  coreutils,
  curl,
  findutils,
  gawk,
  gnugrep,
  gnused,
  testers,
  unzip,
}:

let
  runtimePath = lib.makeBinPath [
    coreutils
    curl
    findutils
    gawk
    gnugrep
    gnused
    unzip
  ];
in
stdenvNoCC.mkDerivation (finalAttrs: {
  __structuredAttrs = true;

  pname = "tfenv";
  version = "3.2.2";

  src = fetchFromGitHub {
    owner = "tfutils";
    repo = "tfenv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-okFPGBZgKgkwxdou9RiERHphzBr5vQQsidoNzEWT7IM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/tfenv $out/share/doc/tfenv

    cp -r bin lib libexec share CHANGELOG.md $out/share/tfenv/

    ln -s $out/share/tfenv/CHANGELOG.md $out/share/doc/tfenv/CHANGELOG.md

    runHook postInstall
  '';

  postFixup = ''
    mkdir -p $out/share/tfenv/bin-extra
    ln -s ${lib.getExe gnugrep} $out/share/tfenv/bin-extra/ggrep

    for f in $out/share/tfenv/bin/* $out/share/tfenv/libexec/*; do
      [ -f "$f" ] || continue
      wrapProgram "$f" \
        --prefix PATH : "${runtimePath}:$out/share/tfenv/bin-extra" \
        --run 'export TFENV_CONFIG_DIR=''${TFENV_CONFIG_DIR:-''${XDG_DATA_HOME:-''$HOME/.local/share}/tfenv}'
    done

    ln -s $out/share/tfenv/bin/tfenv $out/bin/tfenv
    ln -s $out/share/tfenv/bin/terraform $out/bin/terraform
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Terraform version manager";
    homepage = "https://github.com/tfutils/tfenv";
    changelog = "https://github.com/tfutils/tfenv/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kaynetik ];
    mainProgram = "tfenv";
    platforms = lib.platforms.unix;
  };
})
