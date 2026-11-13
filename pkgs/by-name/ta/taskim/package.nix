{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "taskim";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "RohanAdwankar";
    repo = "taskim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I/BHVAEa1uhOUdps7ZezGuuyrj0vszOm2U95BTVFVss=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-38e+xrZNRwqDvOsgBkFL3mtff2UuPGtsp9vJLKfuy6s=";

  meta = {
    description = "TUI Task Manager with vim-ish motions";
    homepage = "https://github.com/RohanAdwankar/taskim";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ idkdontaskm3 ];
    mainProgram = "taskim";
  };
})
