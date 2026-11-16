{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchDebianPatch,
  pkg-config,
  portaudio,
  libvorbis,
  gtk3,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wordwarvi";
  version = "1.0.4-unstable-2025-08-25";

  src = fetchFromGitHub {
    owner = "smcameron";
    repo = "wordwarvi";
    rev = "3611fca0158b20610daa0e5ce9ed86e197660c37";
    hash = "sha256-6mwB54FHcneCf9CmwRMRrORwhhCrkxZTfQ97/c49uMo=";
  };

  patches = [
    (fetchDebianPatch {
      inherit (finalAttrs) pname;
      version = "1.0.4";
      debianRevision = "3";
      patch = "Port-to-GTK-3.patch";
      hash = "sha256-x68mXETSklcwCi/3IaQTXNWW1q/RYeAwcxQ7U9oFaLw=";
    })
  ];

  postPatch = ''
    substituteInPlace Makefile --replace-fail '/bin/rm' 'rm'
  '';

  strictDeps = true;
  __structuredAttrs = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    portaudio
    libvorbis
    gtk3
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "BINDIR=$(PREFIX)/bin"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Retro-styled side scrolling shoot'em up arcade game";
    homepage = "https://smcameron.github.io/wordwarvi/";
    maintainers = with lib.maintainers; [ marcin-serwin ];
    license =
      with lib.licenses;
      AND [
        gpl2Plus

        # Sounds
        cc-by-30
        cc-by-sa-30
      ];
  };
  platforms = lib.platforms.linux;
  mainProgram = "wordwarvi";
})
