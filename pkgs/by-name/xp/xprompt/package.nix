{
  lib,
  stdenv,
  fetchFromGitHub,
  writeText,
  fontconfig,
  libX11,
  libXft,
  libXinerama,
  conf ? null,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "xprompt";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "phillbush";
    repo = "xprompt";
    rev = "v${version}";
    sha256 = "sha256-pOayKngUlrMY3bFsP4Fi+VsOLKCUQU3tdkZ+0OY1SCo=";
  };

  buildInputs = [
    fontconfig
    libX11
    libXft
    libXinerama
  ];

  postPatch = ''
    sed -i "8i #include <time.h>" xprompt.c
  ''
  + (
    let
      configFile =
        if lib.isDerivation conf || builtins.isPath conf then conf else writeText "config.h" conf;
    in
    lib.optionalString (conf != null) "cp ${configFile} config.h"
  );

  makeFlags = [
    "CC:=$(CC)"
    "PREFIX=$(out)"
  ];

  passthru.updateScript = nix-update-script { };

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Dmenu rip-off with contextual completion";
    longDescription = ''
      XPrompt is a prompt for X. XPrompt features a text input field where the
      user can type in a text subject to tab-completion.
    '';
    homepage = "https://github.com/phillbush/xprompt";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
=======
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "xprompt";
  };
}
