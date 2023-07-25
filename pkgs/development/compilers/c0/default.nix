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
}:

stdenv.mkDerivation rec {
  pname = "c0";
  version = "unstable-2022-10-25";

  src = fetchFromBitbucket {
    owner = "c0-lang";
    repo = "c0";
    rev = "7ef3bc9ca232ec41936e93ec8957051e48cacfba";
    sha256 = "sha256-uahF8fOp2ZJE8EhZke46sbPmN0MNHzsLkU4EXkV710U=";
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

  meta = with lib; {
    description = "A small safe subset of the C programming language, augmented with contracts";
    homepage = "https://c0.cs.cmu.edu/";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.unix;
    # line 1: ../../bin/wrappergen: cannot execute: required file not found
    # make[2]: *** [../../lib.mk:83:
    broken = stdenv.isLinux;
  };
}
