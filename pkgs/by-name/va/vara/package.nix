{
  lib,
  stdenv,
  desktop-file-utils,
  fetchurl,
  gtk3,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vara";
  version = "0.1.260926";

  src = fetchurl {
    url = "https://nandakumar.co.in/software/vara/downloads/0.1/vara-0.1.260926.tar.gz";
    hash = "sha256-xcEzK7BjdgMIifMfyepYVfErorJrS6uZSm3Ux5cHJ5o=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    pkg-config
  ];

  buildInputs = [
    desktop-file-utils
    gtk3
  ];

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = true;

  # false alarm, as far as Vara 0.1.260926 is concerned
  NIX_CFLAGS_COMPILE = "-Wno-error=format-security";

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Minimalist digital painting";
    mainProgram = "vara";
    homepage = "https://nandakumar.co.in/software/vara/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ nandedamana ];
  };
})
