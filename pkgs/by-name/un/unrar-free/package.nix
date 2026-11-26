{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  libarchive,
  pkg-config,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unrar-free";
  version = "0.7.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitLab {
    owner = "bgermann";
    repo = "unrar-free";
    tag = finalAttrs.version;
    hash = "sha256-XCBIkpejWcJCQssuwnsQqGa6hylMG81VUGtuEcFdiHI=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libarchive
  ];

  setupHook = ./setup-hook.sh;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Free utility to extract files from RAR archives";
    longDescription = ''
      unrar-free is a free software version of the non-free unrar utility.

      This program is a simple command-line front-end to libarchive, and can list
      and extract RAR archives.

      It does not rival the non-free unrar in terms of features, but
      special care has been taken to ensure it meets most user's needs.
    '';
    homepage = "https://gitlab.com/bgermann/unrar-free";
    changelog = "https://gitlab.com/bgermann/unrar-free/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    mainProgram = "unrar-free";
    maintainers = with lib.maintainers; [
      anthonyroussel
      thiagokokada
    ];
    platforms = lib.platforms.unix;
  };
})
