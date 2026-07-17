{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tudu";
  version = "0.10.4";

  src = fetchurl {
    url = "https://code.meskio.net/tudu/tudu-${finalAttrs.version}.tar.gz";
    sha256 = "14srqn968ii3sr4v6xc5zzs50dmm9am22lrm57j7n0rhjclwbssy";
  };

  buildInputs = [ ncurses ];

  preConfigure = lib.optionalString stdenv.cc.isClang ''
    substituteInPlace configure \
      --replace 'echo "main()' 'echo "int main()'
  '';

  meta = {
    description = "ncurses-based hierarchical todo list manager with vim-like keybindings";
    homepage = "https://code.meskio.net/tudu/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    mainProgram = "tudu";
  };
})
