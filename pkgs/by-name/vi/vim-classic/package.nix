{
  lib,
  stdenv,
  fetchFromSourcehut,
  ncurses,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "vim-classic";
  version = "8.3.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "vim-classic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BJuxs7pOMmPVew+W3d/6KFEah6I8TQoRJ4SK8/4daas=";
  };

  buildInputs = [
    ncurses
  ];

  # Same as `vim`: fortified glibc aborts on `:syntax on` ("buffer overflow detected")
  hardeningDisable =
    if stdenv.cc.isClang then
      [
        "strictflexarrays1"
      ]
    else
      [ "fortify" ];

  enableParallelBuilding = true;
  # The `install` target races between `strip`ping the installed binary and running it to generate
  # the help tags: "strip: ...: Text file busy"
  enableParallelInstalling = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Long-term maintenance fork of Vim 8.2";
    homepage = "https://vim-classic.org";
    downloadPage = "https://sr.ht/~sircmpwn/vim-classic/";
    changelog = "https://git.sr.ht/~sircmpwn/vim-classic/refs/${finalAttrs.src.tag}";
    license = lib.licenses.vim;
    maintainers = with lib.maintainers; [ corps-fini ];
    platforms = lib.platforms.unix;
    mainProgram = "vim";
  };
})
