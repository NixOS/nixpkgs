{ lib
, stdenv
, fetchFromBitbucket
, mlton
, pkg-config
, getopt
, boehmgc
, darwin
, libbacktrace
, libpng
, ncurses
, readline
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "c0";
  version = "0-unstable-2023-09-05";

  src = fetchFromBitbucket {
    owner = "c0-lang";
    repo = "c0";
    rev = "608f97eef5d81bb85963d66f955730dd93996f67";
    hash = "sha256-lRIEtclx+NKxAO72nsvnxVeEGCEe6glC6w8MXh1HEwY=";
  };

  patches = [
    ./use-system-libraries.patch
  ];

  postPatch = ''
    substituteInPlace cc0/Makefile \
      --replace '$(shell ./get_version.sh)' '${version}'
    substituteInPlace cc0/compiler/bin/buildid \
      --replace '`../get_version.sh`' '${version}' \
      --replace '`date`' '1970-01-01T00:00:00Z' \
      --replace '`hostname`' 'nixpkgs'
  '' + lib.optionalString stdenv.isDarwin ''
    for f in cc0/compiler/bin/coin-o0-support cc0/compiler/bin/cc0-o0-support; do
      substituteInPlace $f --replace '$(brew --prefix gnu-getopt)' '${getopt}'
    done
  '';

  preConfigure = ''
    cd cc0/
  '';

  nativeBuildInputs = [
    getopt
    mlton
    pkg-config
  ] ++ lib.optionals stdenv.isDarwin [ darwin.sigtool ];

  buildInputs = [
    boehmgc
    libbacktrace
    libpng
    ncurses
    readline
  ];

  strictDeps = true;

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp
    mv $out/c0-mode/ $out/share/emacs/site-lisp/
  '';

  passthru.updateScript = unstableGitUpdater {
    url = "https://bitbucket.org/c0-lang/c0.git";
  };

  meta = with lib; {
    description = "A small safe subset of the C programming language, augmented with contracts";
    homepage = "https://c0.cs.cmu.edu/";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
    # line 1: ../../bin/wrappergen: cannot execute: required file not found
    # make[2]: *** [../../lib.mk:83:
    broken = stdenv.isLinux;
  };
}
