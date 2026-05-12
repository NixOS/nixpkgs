{
  lib,
  gccStdenv,
  fetchgit,
  ncurses,
}:

gccStdenv.mkDerivation {
  pname = "uemacs";
  version = "4.0-unstable-2021-30-03";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/editors/uemacs/uemacs.git";
    rev = "1c1b25ef723c952ca557cb5ff6d8db159ef1d4bc";
    hash = "sha256-NN3FpeHycPyIhJuEcRm7IO4n+mvAAhxecqSCTuw2elA=";
  };

  buildInputs = [ ncurses ];

  postPatch = ''
    substituteInPlace Makefile --replace "lcurses" "lncurses"
    substituteInPlace Makefile --replace "/usr/bin" "$out/bin"
    substituteInPlace Makefile --replace "/usr/lib" "$out/share/uemacs"

    substituteInPlace epath.h --replace "/usr/global/lib/" "$out/share/uemacs/"
  '';

  makeFlags = [ "CC=${gccStdenv.cc.targetPrefix}cc" ];

  strictDeps = true;

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/{bin,share/uemacs}
    make install
  '';

  meta = {
    description = "Linus Torvalds's random version of microemacs with his personal modifications";
    homepage = "https://git.kernel.org/pub/scm/editors/uemacs/uemacs.git/about/";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ networkexception ];
    mainProgram = "em";
    # MicroEMACS 3.9 can be copied and distributed freely for any
    # non-commercial purposes. MicroEMACS 3.9 can only be incorporated
    # into commercial software with the permission of the current author
    # [Daniel M. Lawrence].
    license = lib.licenses.unfree;
  };
}
