{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uketuner";
  version = "0.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pravin";
    repo = "Ukulele-Tuner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MWiK0AV7Gv6uYo3ZLuXg8ic+LX6mivK/FGyWzp97kG8=";
  };

  cargoHash = "sha256-AF4+NRBSzj96aMFhyi5H1QffA8IvwFWYkNGCaA5UAwU=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ];

  meta = {
    description = "Console utility to tune your ukulele";
    homepage = "https://github.com/pravin/Ukulele-Tuner";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pravin ];
    mainProgram = "uketuner";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
