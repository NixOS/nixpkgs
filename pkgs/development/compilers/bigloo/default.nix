{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "bigloo3.0c-4";

  src = fetchurl {
    url = "ftp://ftp-sop.inria.fr/mimosa/fp/Bigloo/${name}.tar.gz";
    sha256 = "0avcdgfw7g4myqrhcdi3k46qv01p0rmvmpqz4qmim9ccdjrvcyq4";
  };

  patchPhase = ''
    # Fix absolute paths.
    sed -e 's=/bin/mv=mv=g' -e 's=/bin/rm=rm=g'			\
        -e 's=/tmp=$TMPDIR=g' -i configure autoconf/*		\
	[Mm]akefile*   */[Mm]akefile*   */*/[Mm]akefile*	\
	*/*/*/[Mm]akefile*   */*/*/*/[Mm]akefile*		\
	*/*/*/*/*/[Mm]akefile*					\
	comptime/Cc/cc.scm

    # Make sure we don't change string lengths in the generated
    # C files.
    sed -e 's=/bin/rm=     rm=g' -e 's=/bin/mv=     mv=g'	\
	-i comptime/Cc/cc.c
  '';

  checkTarget = "test";

  meta = { 
    description = "Bigloo, an efficient Scheme compiler";

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

    homepage = http://www-sop.inria.fr/mimosa/fp/Bigloo/;
    license = "GPLv2+";
  };
}
