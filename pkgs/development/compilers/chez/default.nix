{ stdenv, fetchgit, coreutils, ncurses, libX11 }:

stdenv.mkDerivation rec {
  name    = "chez-scheme-${version}";
  version = "9.4-${dver}";
  dver    = "20160501";

  src = fetchgit {
    url    = "https://github.com/cisco/chezscheme.git";
    rev    = "8343b7172532a00d2d19914206fcf83c93798c80";
    sha256 = "1jq55sdk468lckccfnqh0iv868bhw6yb9ba9bakqg2pfydb8r4qf";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;
  buildInputs = [ ncurses libX11 ];

  /* Chez uses a strange default search path, which completely
  ** ignores the installation prefix for some reason, and instead
  ** defaults to {/usr,/usr/local,$HOME}/lib for finding the .boot
  ** file.
  **
  ** Also, we patch out a very annoying 'feature' in ./configure, too,
  ** which tries to use 'git' to update submodules.
  **
  ** Finally, we have to also fix a few occurrences to tools with
  ** absolute paths in some helper scripts, otherwise the build will
  ** fail on NixOS or in any chroot build.
  */
  patchPhase = ''
    substituteInPlace ./c/scheme.c \
      --replace "/usr/lib/csv" "$out/lib/csv"

    substituteInPlace ./configure \
      --replace "git submodule init && git submodule update || exit 1" ""

    substituteInPlace ./workarea \
      --replace "/bin/ln" "${coreutils}/bin/ln"

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
