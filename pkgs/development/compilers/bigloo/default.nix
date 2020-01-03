{ fetchurl, stdenv, gmp }:

stdenv.mkDerivation rec {
  pname = "bigloo";
  version = "4.1a-2";

  src = fetchurl {
    url = "ftp://ftp-sop.inria.fr/indes/fp/Bigloo/bigloo${version}.tar.gz";
    sha256 = "09yrz8r0jpj7bda39fdxzrrdyhi851nlfajsyf0b6jxanz6ygcjx";
  };

  propagatedBuildInputs = [ gmp ];

  preConfigure =
    # Help libgc's configure.
    '' export CXXCPP="$CXX -E"
    '';

  patchPhase = ''
    # Fix absolute paths.
    sed -e 's=/bin/mv=mv=g' -e 's=/bin/rm=rm=g'			\
        -e 's=/tmp=$TMPDIR=g' -i autoconf/*		\
	[Mm]akefile*   */[Mm]akefile*   */*/[Mm]akefile*	\
	*/*/*/[Mm]akefile*   */*/*/*/[Mm]akefile*		\
	comptime/Cc/cc.scm gc/install-*

    # Make sure we don't change string lengths in the generated
    # C files.
    sed -e 's=/bin/rm=     rm=g' -e 's=/bin/mv=     mv=g'	\
	-i comptime/Cc/cc.c
  '';

  checkTarget = "test";

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" '';

  meta = {
    description = "Efficient Scheme compiler";
    homepage    = http://www-sop.inria.fr/indes/fp/Bigloo/;
    license     = stdenv.lib.licenses.gpl2Plus;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice ];

    longDescription = ''
      Bigloo is a Scheme implementation devoted to one goal: enabling
      Scheme based programming style where C(++) is usually
      required.  Bigloo attempts to make Scheme practical by offering
      features usually presented by traditional programming languages
      but not offered by Scheme and functional programming.  Bigloo
      compiles Scheme modules.  It delivers small and fast stand alone
      binary executables.  Bigloo enables full connections between
      Scheme and C programs, between Scheme and Java programs, and
      between Scheme and C# programs.
    '';
  };
}
