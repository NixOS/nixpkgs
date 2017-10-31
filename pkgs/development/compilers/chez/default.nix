{ stdenv, fetchgit, coreutils, ncurses, libX11 }:

stdenv.mkDerivation rec {
  name    = "chez-scheme-${version}";
  version = "9.5-${dver}";
  dver    = "20171012";

  src = fetchgit {
    url    = "https://github.com/cisco/chezscheme.git";
    rev    = "adb3b7bb22ddaa1ba91b98b6f4a647427c3a4d9b";
    sha256 = "0hiynf7g0q77ipqxjsqdm2zb0m15bl1hhp615fn3i2hv0qz5a4xr";
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
      --replace "git submodule init && git submodule update || exit 1" "true"

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
