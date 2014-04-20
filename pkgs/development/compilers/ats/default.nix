{ stdenv, fetchurl, gmp }:

let version = "0.2.11"; in stdenv.mkDerivation {
  name = "ats-anairiats-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/ats-lang/ats-lang-anairiats-${version}.tgz";
    sha256 = "0rqykyx5whichx85jr4l4c9fdan0qsdd4kwd7a81k3l07zbd9fc6";
  };
  # this is necessary because atxt files usually include some .hats files
  patches = [ ./install-atsdoc-hats-files.patch ];

  buildInputs = [ gmp ];

  meta = {
    description = "A statically typed programming language that unifies implementation with formal specification";
    homepage = http://www.ats-lang.org/;
    license = stdenv.lib.licenses.gpl3Plus;
    longDescription =
      ''        
        ATS is a programming language with a highly expressive type system
	rooted in the framework Applied Type System. In particular, both
	dependent types and linear types are available in ATS. The current
	implementation of ATS (ATS/Anairiats) is written in ATS itself. It can
	be as efficient as C/C++ and supports a variety of programming
	paradigms.

	In addition, ATS contains a component ATS/LF that supports a form of
	(interactive) theorem proving, where proofs are constructed as total
	functions. With this component, ATS advocates a programming style that
	combines programming with theorem proving. Furthermore, this component
	may be used as a logical framework to encode various deduction systems
	and their (meta-)properties.

	This package contains the compiler atsopt, the frontend atscc,
	and the lexer atslex.
      '';
  };

  platforms = stdenv.lib.platforms.all;
}
