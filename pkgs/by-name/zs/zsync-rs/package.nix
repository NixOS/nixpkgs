{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zsync-rs";
  version = "0.3.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-LAU51dbMNl79reHkC6EyHfyZANyFVqgmceOzs54iB10=";
  };

  cargoHash = "sha256-HUba2g4UTzsDc62DoDVyrYWSN3kGyeo28nHFPR5C0Ic=";

  postInstall = ''
    mv $out/bin/zsync $out/bin/zsync-rs
  '';

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Rsync algorithm over HTTP with JSON progress";
    homepage = "https://github.com/QaidVoid/zsync-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MuntasirSZN ];
    platforms = lib.platforms.unix;
    mainProgram = "zsync-rs";
  };
})
