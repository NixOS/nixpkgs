{
  lib,
  gccStdenv,
  fetchgit,
  ncurses,
}:

gccStdenv.mkDerivation {
  pname = "uemacs";
  version = "4.0-unstable-2018-07-19";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/editors/uemacs/uemacs.git";
    rev = "1cdcf9df88144049750116e36fe20c8c39fa2517";
    hash = "sha256-QSouqZiBmKBU6FqRRfWtTGRIl5sqJ8tVPYwdytt/43w=";
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

  meta = with lib; {
    description = "Linus Torvalds's random version of microemacs with his personal modifications";
    homepage = "https://git.kernel.org/pub/scm/editors/uemacs/uemacs.git/about/";
    platforms = platforms.all;
    maintainers = with maintainers; [ networkexception ];
    mainProgram = "em";
    # MicroEMACS 3.9 can be copied and distributed freely for any
    # non-commercial purposes. MicroEMACS 3.9 can only be incorporated
    # into commercial software with the permission of the current author
    # [Daniel M. Lawrence].
    license = licenses.unfree;
  };
}
