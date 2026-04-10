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
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "tfutils";
    repo = "tfenv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2Fpaj/UQDE7PNFX9GNr4tygvKmm/X0yWVVerJ+Y6eks=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib $out/libexec $out/share

    cp -r lib/* $out/lib/
    cp -r libexec/* $out/libexec/
    cp -r share/* $out/share/

    install -m0644 CHANGELOG.md $out/CHANGELOG.md

    install -m0755 bin/tfenv $out/bin/tfenv
    install -m0755 bin/terraform $out/bin/terraform

    runHook postInstall
  '';

  postFixup = ''
    for f in $out/bin/* $out/libexec/*; do
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
