{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  groff,
}:

stdenv.mkDerivation rec {
  pname = "wiggle";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "neilbrown";
    repo = "wiggle";
    rev = "v${version}";
    sha256 = "18ilzr9sbal1j8p1d94ilm1j5blac5cngvcvjpdmgmpw6diy2ldf";
  };

  buildInputs = [
    ncurses
    groff
  ];

  configurePhase = ''
    makeFlagsArray=( CFLAGS="-I. -O3"
                     STRIP="-s"
                     INSTALL="install"
                     BINDIR="$out/bin"
                     MANDIR="$out/share/man"
                   )
    patchShebangs .
  '';

  meta = with lib; {
    homepage = "https://blog.neil.brown.name/category/wiggle/";
    description = "Tool for applying patches with conflicts";
    mainProgram = "wiggle";
    longDescription = ''
      Wiggle applies patches to a file in a similar manner to the patch(1)
      program. The distinctive difference is, however, that wiggle will
      attempt to apply a patch even if the "before" part of the patch doesn't
      match the target file perfectly. This is achieved by breaking the file
      and patch into words and finding the best alignment of words in the file
      with words in the patch. Once this alignment has been found, any
      differences (word-wise) in the patch are applied to the file as best as
      possible. Also, wiggle will (in some cases) detect changes that have
      already been applied, and will ignore them.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
