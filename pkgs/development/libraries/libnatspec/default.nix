{ stdenv, fetchurl, autoreconfHook, popt, libiconv }:

stdenv.mkDerivation (rec {
  name = "libnatspec-0.3.0";

  src = fetchurl {
    url = "mirror://sourceforge/natspec/${name}.tar.bz2";
    sha256 = "0wffxjlc8svilwmrcg3crddpfrpv35mzzjgchf8ygqsvwbrbb3b7";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ popt ];

  meta = {
    homepage = http://natspec.sourceforge.net/ ;
    description = "A library intended to smooth national specificities in using of programs";
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ ];
  };
} // stdenv.lib.optionalAttrs (!stdenv.isLinux) {
  NIX_LDFLAGS = "-liconv";
  propagatedBuildInputs = [ libiconv ];
})
