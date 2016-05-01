{ stdenv, fetchgit, ncurses, libX11 }:

stdenv.mkDerivation rec {
  name    = "chez-scheme-${version}";
  version = "9.4-${dver}";
  dver    = "20160430";

  src = fetchgit {
    url    = "https://github.com/cisco/ChezScheme.git";
    rev    = "63a97939896c2a89fcffdf16c8b783efaeb816b5";
    sha256 = "1c58xjslgn7xnfy9j5p9b6sn0wzv2mk7zlmhflydzil7iimchjsi";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;
  buildInputs = [ ncurses libX11 ];

  /* Chez uses a strange default search path, which completely
  ** ignores the installation prefix for some reason, and instead
  ** defaults to {/usr,/usr/local,$HOME}/lib for finding the .boot
  ** file.
  **
  ** Also, we patch out a very annoying 'feature' in ./configure, too.
  */
  patchPhase = ''
    substituteInPlace c/scheme.c \
      --replace "/usr/lib/csv" "$out/lib/csv"

    substituteInPlace ./configure \
      --replace "git submodule init && git submodule update || exit 1" ""
  '';

  /* Don't use configureFlags, since that just implicitly appends
  ** everything onto a --prefix flag, which ./configure gets very angry
  ** about.
  */
  configurePhase = ''
    ./configure --threads --installprefix=$out --installman=$out/share/man
  '';

  meta = {
    description = "A powerful and incredibly fast R6RS Scheme compiler";
    homepage    = "http://www.scheme.com";
    license     = stdenv.lib.licenses.asl20;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice ];
  };
}
