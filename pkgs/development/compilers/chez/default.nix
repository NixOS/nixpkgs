{ stdenv, fetchgit, coreutils, ncurses, libX11 }:

stdenv.mkDerivation rec {
  name    = "chez-scheme-${version}";
  version = "9.4-${dver}";
  dver    = "20160507";

  src = fetchgit {
    url    = "https://github.com/cisco/chezscheme.git";
    rev    = "65df1d1f7c37f5b5a93cd7e5b475dda9dbafe03c";
    sha256 = "1b273il3njnn04z55w1hnygvcqllc6p5qg9mcwh10w39fwsd8fbs";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;
  buildInputs = [ ncurses libX11 ];

  /* We patch out a very annoying 'feature' in ./configure, which
  ** tries to use 'git' to update submodules.
  **
  ** We have to also fix a few occurrences to tools with absolute
  ** paths in some helper scripts, otherwise the build will fail on
  ** NixOS or in any chroot build.
  */
  patchPhase = ''
    substituteInPlace ./configure \
      --replace "git submodule init && git submodule update || exit 1" ""

    substituteInPlace ./workarea \
      --replace "/bin/ln" "${coreutils}/bin/ln" \
      --replace "/bin/cp" "${coreutils}/bin/cp"

    substituteInPlace ./makefiles/installsh \
      --replace "/usr/bin/true" "${coreutils}/bin/true"
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
