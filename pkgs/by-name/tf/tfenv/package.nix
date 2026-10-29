{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  unzip,
  curl,
  gnugrep,
  gnused,
  gawk,
  coreutils,
}:

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
    for f in $out/share/tfenv/bin/* $out/share/tfenv/libexec/*; do
      [ -f "$f" ] || continue
      wrapProgram "$f" \
        --prefix PATH : "${
          lib.makeBinPath [
            unzip
            curl
            gnugrep
            gnused
            gawk
            coreutils
          ]
        }"
    done

    ln -s $out/share/tfenv/bin/tfenv $out/bin/tfenv
    ln -s $out/share/tfenv/bin/terraform $out/bin/terraform
  '';

  passthru.updateScript = nix-update-script { };

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
